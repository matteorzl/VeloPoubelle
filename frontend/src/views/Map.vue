<template>
  <div style="width: 100%; float: right;">
    <div id="map" class="map-container"></div>
    <!-- Bouton pour calculer les itinéraires -->
    <div class="controls" style="margin: 5%">
      <div v-if="numberOfCyclists === 0">Il n'y a aucun cycliste dans votre base</div>
      <div v-else>Nombre de cycliste disponible : {{ numberOfCyclists }}</div>
      <button @click="calculateRoutes" class="custombutton">Calculer les itinéraires</button>
    </div>

    <!-- Sélection des cyclistes -->
    <div v-if="formattedRoutes.length > 0" class="d-flex flex-column justify-content-center" style="margin: 5%">
      <h3>Itinéraires calculés</h3>
      <table class="custom-table">
      <thead>
        <tr>
          <th>#</th>
          <th>Trajets</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(route, index) in formattedRoutes" :key="index">
          <td>{{ index + 1 }}</td>
          <td>
            <ul>
              <li>Trajet : {{ route }}</li>
            </ul>
          </td>
          <td>
            <!-- Bouton pour afficher le trajet -->
            <button @click="displayRoute(index)" class="custombutton">Voir</button>
          </td>
        </tr>
      </tbody>
    </table>
      <button @click="saveTournees" class="custombutton">Enregistrer les tournées</button>

    </div>

    
    <!-- Carte -->
    
  </div>
</template>


<script setup lang="ts">
import axios from 'axios';
axios.defaults.baseURL = 'http://localhost:3000';

import { onMounted, ref } from 'vue';

import L from 'leaflet';

import { optimizeRoute } from '../components/dijkstra';

import 'leaflet/dist/leaflet.css';


interface Station {

  id_arret: number;

  lat: number;

  lng: number;

  nom: string;

}

const map = ref<L.Map>();

const numberOfCyclists = ref();

const cyclistes = ref();

const selectedCyclist = ref('');

const bikeMarkers = ref<L.Marker[]>([]);

const routeLines = ref<L.Polyline[]>([]);

const allStations = ref<Station[]>([]);

const cyclistRoutes = ref<Station[][]>([]);

const formattedRoutes = ref<string[]>([]);

const stationMarkers = ref<L.Marker[]>([]);

const loadRoute = async (): Promise<Station[]> => {

  try {

    const response = await axios.get('/api/map/arret');

    return response.data.rows || [];

  } catch (error) {

    console.error('Erreur lors du chargement de l\'itinéraire:', error);

    return [];

  }

};


const assignments = ref<Record<number,string>>({}); // Clé : index de la route, Valeur : ID du cycliste

const assignRoutes = () => {
  for (const [routeIndex, cyclistName] of Object.entries(assignments.value)) {
    if (!cyclistName) {
      console.warn(`La route ${routeIndex} n'a pas été assignée.`);
      continue;
    }
    console.log(`Route ${routeIndex} assignée à Cycliste ${cyclistName}`);
  }
};

const CyclistAmount = async () => {

try {

  const response = await axios.get('/api/cycliste');

  numberOfCyclists.value = response.data.count;

  cyclistes.value = response.data.rows

} catch (error) {

  console.error('Erreur lors du chargement de l\'itinéraire:', error);

  return [];

}

};

const saveTournees = async () => {
  if (!formattedRoutes.value.length) {
    alert("Aucun itinéraire à enregistrer.");
    return;
  }

  const tournees = formattedRoutes.value.map((route, index) => ({
    id_tournee: index + 1, // ID tournées
    date: new Date().toISOString().split('T')[0], // Date actuelle
    velo_id: null, // Pas de vélo assigné pour l'instant
    etat: 'planifiee', // État initial
    nom: `${route}`, // Nom de la tournée
  }));

  const trajets = cyclistRoutes.value.flatMap((route, tourneeIndex) => 
    route.map((station, order) => ({
      tournee_id: tourneeIndex + 1, // Associe à l'ID de la tournée
      lat: station.lat,
      lng: station.lng,
      ordre_passage: order + 1, // Ordre de passage
    }))
  );

  try {
    // Enregistrer les tournées
    const tourneeResponse = await axios.post('/api/tournee', { tournees });
    alert(tourneeResponse.data.message || 'Tournées enregistrées avec succès.');

    // Enregistrer les trajets
    const trajetResponse = await axios.post('/api/trajet', { trajets });
    alert(trajetResponse.data.message || 'Trajets enregistrés avec succès.');
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement:', error);
    alert('Erreur lors de l\'enregistrement.');
  }
};


const clearMap = () => {
  if (!map.value) return;

  // Effacez tous les marqueurs des stations
  stationMarkers.value.forEach(marker => {
    if (marker && map.value) {
      marker.removeFrom(map.value);
    }
  });
  stationMarkers.value = [];

  // Effacez tous les marqueurs des vélos
  bikeMarkers.value.forEach(marker => {
    if (marker && map.value) {
      marker.removeFrom(map.value);
    }
  });
  bikeMarkers.value = [];

  // Effacez toutes les lignes de trajet
  routeLines.value.forEach(line => {
    if (line && map.value) {
      line.removeFrom(map.value);
    }
  });
  routeLines.value = [];
};

const showRouteOnMap = (route: Station[], color: string) => {
  if (!map.value) return;
  clearMap();

  const routeLine = L.polyline(
    route.map(station => [station.lat, station.lng]),
    { color, weight: 3 }
  );

  routeLine.addTo(map.value);
  routeLines.value.push(routeLine);
};


const showSelectedCyclistRoute = () => {
  if (!map.value) return;

  // Effacez les tracés actuels de la carte
  clearMap();

  // Vérifiez si un cycliste est sélectionné
  if (!selectedCyclist.value) return;

  // Trouvez la route assignée au cycliste sélectionné
  const assignedRouteEntry = Object.entries(assignments.value).find(
    ([, cyclistId]) => cyclistId === selectedCyclist.value
  );

  if (!assignedRouteEntry) {
    console.warn("Aucune route assignée à ce cycliste.");
    return;
  }

  const routeIndex = parseInt(assignedRouteEntry[0]); // Obtenez l'index de la route
  const route = cyclistRoutes.value[routeIndex]; // Récupérez la route correspondante

  if (!route || route.length === 0) {
    console.warn("La route assignée est vide.");
    return;
  }

  // Affichez la route sur la carte
  const routeColor = `hsl(${(360 / cyclistRoutes.value.length) * routeIndex}, 70%, 50%)`;
  showRouteOnMap(route, routeColor);

  // Ajoutez un marqueur de départ (optionnel)
  const bikeIcon = L.icon({
    iconUrl: '/src/assets/bike.png',
    iconSize: [32, 32],
    iconAnchor: [16, 16],
  });

  const marker = L.marker([route[0].lat, route[0].lng], { icon: bikeIcon });
  marker.addTo(map.value);
  bikeMarkers.value.push(marker);

  // Animer le vélo sur la route
  animateBikeAlongRoute(marker, route);
};



const calculateRoutes = async () => {
  if (!map.value) return;

  clearMap();
  selectedCyclist.value = '';

  if (allStations.value.length === 0) {
    allStations.value = await loadRoute();

    const uniqueStations = new Map<string, Station>();
    allStations.value.forEach(station => {
      const key = `${station.lat},${station.lng},${station.nom}`;
      uniqueStations.set(key, station);
    });

    allStations.value = Array.from(uniqueStations.values());

    stationMarkers.value.forEach(marker => {
      if (marker && map.value) {
        marker.removeFrom(map.value);
      }
    });

    stationMarkers.value = [];
    allStations.value.forEach(station => {
      if (!map.value) return;
      const marker = L.marker([station.lat, station.lng]).bindPopup(`<b>${station.nom}</b>`);
      marker.addTo(map.value);
      stationMarkers.value.push(marker);
    });
  }

  if (numberOfCyclists.value <= 0) return;

  const stationsPerCyclist = Math.ceil(allStations.value.length / numberOfCyclists.value);

  cyclistRoutes.value = Array.from({ length: numberOfCyclists.value }, (_, i) => {
    const start = i * stationsPerCyclist;
    const end = Math.min(start + stationsPerCyclist, allStations.value.length);
    const stationsGroup = allStations.value.slice(start, end);
    return optimizeRoute(stationsGroup);
  });

  // Formattez les trajets
  formattedRoutes.value = cyclistRoutes.value.map(route => {
    if (route.length > 1) {
      return `${route[0].nom} - ${route[route.length - 1].nom}`;
    } else if (route.length === 1) {
      return `Point unique : "${route[0].nom}"`;
    } else {
      return 'Aucun trajet disponible';
    }
  });
};

const displayRoute = (routeIndex: number) => {
  if (!map.value) return;

  // Effacez tous les marqueurs et tracés actuels
  clearMap();

  // Récupérez le trajet correspondant
  const route = cyclistRoutes.value[routeIndex];
  if (!route || route.length === 0) {
    console.warn('Trajet vide ou invalide.');
    return;
  }

  // Couleur unique pour le trajet
  const color = `hsl(${(360 / cyclistRoutes.value.length) * routeIndex}, 70%, 50%)`;

  // Ajoutez les marqueurs pour les stations du trajet
  route.forEach(station => {
    const marker = L.marker([station.lat, station.lng]).bindPopup(`<b>${station.nom}</b>`);
    marker.addTo(map.value);
    stationMarkers.value.push(marker);
  });

  // Tracez une ligne reliant les stations
  const routeLine = L.polyline(
    route.map(station => [station.lat, station.lng]),
    { color, weight: 3 }
  );
  routeLine.addTo(map.value);
  routeLines.value.push(routeLine);
};



const animateBikeAlongRoute = (marker: L.Marker, stations: Station[]) => {

  let index = 0;

  const steps = 100;

  const delay = 90 * 1000 / steps;


  const moveBike = () => {

    if (index >= stations.length - 1) {

      index = 0;

    }


    const start = stations[index];

    const end = stations[index + 1];

    let step = 0;


    const animateStep = () => {

      if (step > steps) {

        index++;

        if (index < stations.length - 1) {

          moveBike();

        } else {

          index = 0;

          moveBike();

        }

        return;

      }


      const lat = start.lat + ((end.lat - start.lat) * step) / steps;

      const lng = start.lng + ((end.lng - start.lng) * step) / steps;


      marker.setLatLng([lat, lng]);

      step++;

      setTimeout(animateStep, delay);

    };


    animateStep();

  };


  moveBike();

};


onMounted(() => {

  map.value = L.map('map').setView([48.9111, 2.3055], 10);

  CyclistAmount()

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {

    maxZoom: 18,

    attribution: '&copy; OpenStreetMap contributors'

  }).addTo(map.value);

});

</script>


<style scoped>

.map-container {

  width: 100%;

  height: 50%;

}


.controls {

  display: flex;

  flex-direction: column;

  gap: 1rem;

}


.control-group {

  display: flex;

  gap: 1rem;

  align-items: center;

}

.custom-table {
  width: 100%;
  border-collapse: collapse;
  margin: 20px 0;
}

.custom-table th,
.custom-table td {
  border: 1px solid #ccc;
  padding: 10px;
  text-align: left;
}

.custom-table th {
  background-color: #f4f4f4;
}

.custom-table ul {
  margin: 0;
  padding-left: 20px;
  list-style: disc;
}

.custominput {

  background-color: #826b48 !important;

  border: none !important;

  margin-bottom: 1em;

  color: white !important;

  padding: 8px;

  border-radius: 4px;

  width: 200px;

}


.custominput:focus {

  outline: none;

  box-shadow: 0 0 0 2px rgba(130, 107, 72, 0.5);

}


.custombutton {

  background-color: #826b48;

  color: white;

  border: none;

  padding: 8px 16px;

  border-radius: 4px;

  cursor: pointer;

  transition: background-color 0.2s;

}


.custombutton:hover {

  background-color: #6f5a3d;

}


select.custominput {

  appearance: none;

  padding-right: 24px;

  background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='white'%3e%3cpath d='M7 10l5 5 5-5z'/%3e%3c/svg%3e");

  background-repeat: no-repeat;

  background-position: right 8px center;

  background-size: 16px;

}

</style>