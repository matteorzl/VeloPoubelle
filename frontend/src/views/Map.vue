<script setup lang="ts">
import axios from 'axios';
import { onMounted, ref } from 'vue';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import polyline from '@mapbox/polyline';

interface Station {
  lat: number;
  lng: number;
  name: string;
  route: string;
  visited: boolean; // Ajout du champ pour suivre les rues parcourues
}

interface Intersection extends Station {
  count: number;
  routes: string[];
}

const map = ref<L.Map | null>(null);
const allStations = ref<Station[]>([]);
const intersections = ref<Intersection[]>([]);
const isGeneratingRoutes = ref(false);
const baseStation = { name: "Porte d'Ivry", lat: 48.8179, lng: 2.3703 };
const ORS_API_KEY = '5b3ce3597851110001cf624899c5ec69e54e4fd98fcf69fe706c134d';
const ORS_BASE_URL = 'https://api.openrouteservice.org/v2/directions/foot-walking';

const routeOptions = ref([
  { name: 'Alsace-Lorraine', file: 'AlsaceLorraine.json' },
  // { name: 'GentyMagre', file: 'GentyMagre.json' },
  // { name: 'Bedelières', file: 'Bedelieres.json' },
  /**{ name: 'Arts', file: 'Arts.json' },
  { name: 'Bedelières', file: 'Bedelieres.json' },
  { name: 'Croix-Baragnon', file: 'CroixBaragnon.json' },
  { name: 'Daurade', file: 'Daurade.json' },
  { name: 'Espinasse', file: 'Espinasse.json' },
  { name: 'Etroite', file: 'Etroite.json' },
  { name: 'Filatiers', file: 'Filatiers.json' },
  { name: 'Fonderie', file: 'Fonderie.json' },
  { name: 'GentyMagre', file: 'GentyMagre.json' },
  { name: 'Gestes', file: 'Gestes.json' },
  { name: 'JeanJaures', file: 'JeanJaures.json' },
  { name: 'Mage', file: 'Mage.json' },
  { name: 'May', file: 'May.json' },
  { name: 'Merlane', file: 'Merlane.json' },
  { name: 'Pargaminieres', file: 'Pargaminieres.json' },
  { name: 'Peyras', file: 'Peyras.json' },
  { name: 'Peyrolieres', file: 'Peyrolieres.json' },
  { name: 'SaintAntoineduT', file: 'SaintAntoineduT.json' },
  { name: 'SaintRome', file: 'SaintRome.json' },
  { name: 'Taur', file: 'Taur.json' },
  { name: 'Tourneurs', file: 'Tourneurs.json' },
  { name: 'Trinite', file: 'Trinite.json' },
  { name: 'Velane', file: 'Velane.json' },**/
]);

const snapToRoads = (coordinates: [number, number][]): [number, number][] => {
  return coordinates.map(([lng, lat]) => {
    // Ajuster les coordonnées pour être plus proches des routes
    return [
      Math.round(lng * 10000) / 10000,
      Math.round(lat * 10000) / 10000
    ];
  });
};

const fetchRouteFromORS = async (coordinates: [number, number][]) => {
  if (coordinates.length < 2) return null;
  
  const snappedCoordinates = snapToRoads(coordinates);
  
  try {
    const response = await axios({
      method: 'POST',
      url: ORS_BASE_URL,
      headers: {
        'Authorization': ORS_API_KEY,
        'Content-Type': 'application/json',
        'Accept': 'application/json, application/geo+json, application/gpx+xml'
      },
      data: {
        coordinates: snappedCoordinates,
        radiuses: coordinates.map(() => 100), // Augmenté à 100m pour plus de flexibilité
        continue_straight: false, // Permettre les virages naturels
        geometry: true,
        format: 'geojson',
        instructions: false,
        preference: 'shortest' // Préférer le chemin le plus court
      }
    });

    return response.data;
  } catch (error) {
    if (axios.isAxiosError(error) && error.response?.status === 404) {
      console.warn('Point non routable trouvé, passage au suivant');
      return null;
    }
    throw error;
  }
};

// Ajout de la gestion de l’autonomie et du retour à la base
const checkBikeStatus = (distanceTravelled: number, stopsMade: number, isWinter: boolean = false) => {
  const maxDistance = isWinter ? 45 : 50; // Autonomie réduite en hiver
  const maxStops = 3; // 200kg max, 50kg par arrêt

  if (distanceTravelled >= maxDistance || stopsMade >= maxStops) {
    console.log("Retour à la base nécessaire.");
    return true;
  }
  return false;
};

const updateRouteStatus = (route) => {
  route.stations.forEach(station => {
    station.visited = true; // Marquer comme parcourue
  });
};

const splitIntoChunks = (arr, chunkSize) => {
  const chunks = [];
  for (let i = 0; i < arr.length; i += chunkSize) {
    chunks.push(arr.slice(i, i + chunkSize));
  }
  return chunks;
};

const generateRoutes = async () => {
  if (isGeneratingRoutes.value) return;
  isGeneratingRoutes.value = true;

  const bikeStatus = { distance: 0, stops: 0 }; // Suivi de la distance et des arrêts

  try {
    // Préparer les coordonnées avec la base comme point de départ
    const baseCoords = [baseStation.lng, baseStation.lat];
    const stationCoords = allStations.value.map(station => [station.lng, station.lat] as [number, number]);
    const coordinates = [baseCoords, ...stationCoords]; // Insérer la base au début

    // Diviser les coordonnées en paires (chunks de 2)
    const chunks = splitIntoChunks(coordinates, 2);

    for (const chunk of chunks) {
      try {
        // Appel à l'API avec un chunk de 2 stations
        const routeData = await fetchRouteFromORS(chunk);

        if (routeData) {
          displayRouteOnMap(routeData);

          // Mise à jour de l'état du vélo
          bikeStatus.distance += 0.5; // Supposons 0,5 km entre deux stations
          bikeStatus.stops++; // Un arrêt par station visitée

          // Vérifier si le vélo doit retourner à la base
          if (checkBikeStatus(bikeStatus.distance, bikeStatus.stops)) {
            console.log("Retour à la base nécessaire.");

            // Générer un itinéraire vers la station de base
            const returnRoute = await fetchRouteFromORS([
              chunk[chunk.length - 1], // Dernière station visitée
              [baseStation.lng, baseStation.lat], // Coordonnées de la base
            ]);

            if (returnRoute) {
              displayRouteOnMap(returnRoute, true); // Afficher en vert pour indiquer le retour
              console.log(`Retour à la base effectué (${baseStation.name}).`);
            }

            // Réinitialiser le statut du vélo après retour
            bikeStatus.distance = 0;
            bikeStatus.stops = 0;

            // Reprendre depuis la base
            const nextStart = [baseStation.lng, baseStation.lat];
            coordinates.unshift(nextStart); // Recommencer à partir de la base
          }
        }

        // Délai entre les requêtes pour respecter les limites de l'API
        await new Promise(resolve => setTimeout(resolve, 1500));
      } catch (error) {
        console.warn('Erreur lors de la génération d\'un segment:', error);
        continue; // Continuer avec le prochain segment en cas d'erreur
      }
    }
  } finally {
    isGeneratingRoutes.value = false;
  }
};

const displayRouteOnMap = (route, isCompleted = false) => {
  const color = isCompleted ? "green" : "blue"; // Vert pour les rues parcourues

  const decodedCoords = polyline.decode(route.routes[0].geometry);
  const leafletCoords = decodedCoords.map(([lat, lng]) => [lat, lng]);

  L.polyline(leafletCoords, {
    color,
    weight: 3,
    opacity: 0.8,
  }).addTo(map.value);
};

const loadRoute = async (file: string, routeName: string) => {
  try {
    const response = await fetch(`/src/components/map/${file}`);
    const data = await response.json();

    if (data.stations?.length > 0) {
      const coords = data.stations.map((station: any) => [station.lat, station.lng]);

      // Afficher les marqueurs pour les stations
      if (map.value) {
        data.stations.forEach((station: any) => {
          L.marker([station.lat, station.lng])
            .addTo(map.value!)
            .bindPopup(`<b>${station.name}</b>`);
        });

        // Supprimer cette partie pour ne pas tracer de polyline entre les marqueurs
        /*
        L.polyline(coords, { color: 'blue' }).addTo(map.value);
        */
      }

      allStations.value.push(...data.stations.map((station: any) => ({
        lat: station.lat,
        lng: station.lng,
        name: station.name,
        route: routeName,
        visited: false // Initialiser les stations comme non visitées
      })));
    }
  } catch (error) {
    console.error('Erreur lors du chargement de l\'itinéraire:', error);
  }
};


// Fonction pour charger les stations depuis un fichier JSON
const loadStationData = async (file: string) => {
  try {
    const response = await fetch(`/src/components/map/${file}`);
    const data = await response.json();

    if (data.stations?.length > 0) {
      // Ajouter les stations à la liste allStations avec le champ visited
      const stations = data.stations.map((station: any) => ({
        lat: station.lat,
        lng: station.lng,
        name: station.name,
        route: file,
        visited: false // Marquer les stations comme non visitées
      }));

      // Ajouter les stations à la liste principale
      allStations.value.push(...stations);

      // Afficher les stations sur la carte avec un marqueur
      if (map.value) {
        data.stations.forEach((station: any) => {
          L.marker([station.lat, station.lng])
            .addTo(map.value!)
            .bindPopup(`<b>${station.name}</b>`);
        });
      }
    }
  } catch (error) {
    console.error('Erreur lors du chargement des stations:', error);
  }
};

// Afficher les intersections sur la carte
const detectIntersections = () => {
  const coordMap = new Map();

  allStations.value.forEach(station => {
    const key = `${station.lat},${station.lng}`;
    if (!coordMap.has(key)) {
      coordMap.set(key, { ...station, count: 0, routes: [] });
    }
    const entry = coordMap.get(key);
    entry.count++;
    entry.routes.push(station.route);
  });

  intersections.value = Array.from(coordMap.values()).filter(entry => entry.count > 1);
};

onMounted(async () => {
  map.value = L.map("map").setView([48.8566, 2.3522], 15); // Paris

  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    maxZoom: 19,
    attribution: "© OpenStreetMap contributors",
  }).addTo(map.value);

  // Charger les itinéraires comme précédemment
  for (const route of routeOptions.value) {
    await loadRoute(route.file, route.name);
  }

  // Charger les stations et ajouter le champ 'visited'
  for (const route of routeOptions.value) {
    await loadStationData(route.file); // Charger les stations en même temps
  }

  detectIntersections();

  // Afficher les intersections sur la carte
  if (map.value) {
    intersections.value.forEach((intersection) => {
      L.circleMarker([intersection.lat, intersection.lng], {
        radius: 8,
        color: "orange",
        fillColor: "#f03",
        fillOpacity: 0.5,
      })
        .addTo(map.value!)
        .bindPopup(`Intersection entre : ${intersection.routes.join(", ")}`);
    });
  }
});

</script>

<template>
  <div class="metro-map">
    <button 
      @click="generateRoutes" 
      :disabled="isGeneratingRoutes"
      class="generate-routes-btn"
    >
      {{ isGeneratingRoutes ? 'Génération en cours...' : 'Générer Itinéraires' }}
    </button>
    <div id="map" class="map-container"></div>
  </div>
</template>

<style scoped>
.metro-map {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.generate-routes-btn {
  background-color: #007bff;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.generate-routes-btn:hover:not(:disabled) {
  background-color: #0056b3;
}

.generate-routes-btn:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

.map-container {
  width: 100%;
  height: 500px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
</style>