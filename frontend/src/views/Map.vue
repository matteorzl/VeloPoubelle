<template>
  <div style="width: 100%; float: right;">
    <div id="map" class="map-container"></div>
    <div class="controls" style="margin: 5%">
      <div v-if="numberOfCyclists === 0">Il n'y a aucun cycliste dans votre base</div>
      <div v-else>Nombre de cycliste disponible : {{ numberOfCyclists }}</div>
      <button @click="calculateRoutes" class="custombutton">Calculer les itinéraires</button>
      <!-- Tableau des itinéraires calculés -->
      <div class="flex flex-column items-center justify-content-center" v-if="!showRecordedRoutes">
        <h3>Itinéraires calculés</h3>
        <table class="custom-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Trajets</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(route, index) in formattedRoutes" :key="index">
              <td>{{ index + 1 }}</td>
              <td>{{ route }}</td>
              <td class="flex justify-content-evenly  ">
                <button @click="displayRoute(index)" class="custombutton w-25">Voir</button>
                <select 
                  v-model="assignments[index]" 
                  class="custominput" 
                  @change="updateAssignment(index)"
                >
                  <option value="" disabled>Choisissez un cycliste</option>
                  <option 
                    v-for="cyclist in cyclistes" 
                    :key="cyclist.id_utilisateur" 
                    :value="cyclist.id_utilisateur"
                  >
                    {{ cyclist.nom }}
                  </option>
                </select>
              </td>
            </tr>
          </tbody>
        </table>
        <div class="flex justify-content-evenly  ">
          <button @click="saveTournees" class="custombutton">Enregistrer les tournées</button>
          <button @click="showRecordedRoutes = true" class="custombutton">Annuler</button>
        </div>
      </div>

      <!-- Tableau des tournées enregistrées -->
      <div v-else>
        <h3>Tournées enregistrées</h3>
        <table class="custom-table">
          <thead>
            <tr>
              <th>ID Tournée</th>
              <th>Cycliste</th>
              <th>Nom</th>
              <th>Nombre d'arrêts</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="route in recordedRoutes" :key="route.idTournee">
              <td>{{ route.idTournee }}</td>
              <td>{{ route.cycliste }}</td>
              <td>{{ route.nom }}</td>
              <td>{{ route.stops }}</td>
              <td>
                <button @click="showRecordedRoute(route.idTournee)" class="custombutton">Voir</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>


<script setup lang="ts">
import axios from 'axios';
import { onMounted, ref, type Ref } from 'vue';
import L from 'leaflet';
import { optimizeRoute } from '../components/dijkstra';
import 'leaflet/dist/leaflet.css';
import { useToast } from "primevue/usetoast";
axios.defaults.baseURL = 'http://localhost:3000';


interface Station {

  id_arret: number;

  lat: number;

  lng: number;

  nom: string;

}

const message = ref('');
const toast = useToast();
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
const assignments = ref<Record<number, number>>({});
const showRecordedRoutes = ref(false);
const recordedRoutes = ref([]);

const loadRoute = async (): Promise<Station[]> => {
  try {
    const response = await axios.get('/api/map/arret');
    return response.data.rows || [];
  } catch (error) {
    console.error('Erreur lors du chargement de l\'itinéraire:', error);
    return [];
  }

};

const showWarn = (message: any) => {
  toast.add({ severity: 'error', summary: "Message d'erreur", detail: message });
};
const showSuccess = (message: any) => {
  toast.add({ severity: 'success', summary: "Succès", detail: message, life: 3000 });
};

const updateAssignment = (routeIndex: number) => {
  const assignedCyclistId = assignments.value[routeIndex];

  if (!assignedCyclistId) {
    console.warn("Aucun cycliste sélectionné pour cette tournée.");
    return;
  }
  axios
    .patch(`/api/tournee/${routeIndex + 1}`, { id_utilisateur: assignedCyclistId })
    .then(() => {
      message.value = `Tournée ${routeIndex + 1} attribuée avec succès à l'utilisateur ${assignedCyclistId}.`;
      showSuccess(message)
    })
    .catch(error => {
      console.log(error);
      message.value ="Erreur lors de l'attribution.";
      showWarn(message)
    });
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

const fetchRecordedRoutes = async () => {
  try {
    const response = await axios.get('/api/tournee');
    console.log(response)
    recordedRoutes.value = response.data.rows.map((route: any) => ({
      idTournee: route.id_tournee,
      nom: route.nom,
      cycliste: route.cycliste,
      stops: route.nombre_arrets,
    }));
    showRecordedRoutes.value = true;
  } catch (error) {
    console.error('Erreur lors de la récupération des tournées enregistrées:', error);
    showWarn('Impossible de charger les tournées.');
  }
};

const saveTournees = async () => {
  if (!formattedRoutes.value.length) {
    message.value = "Aucun itinéraire à enregistrer.";
    showWarn(message)
    return;
  }

  // Vérifiez que toutes les tournées ont un cycliste assigné
  const unassignedRoutes = formattedRoutes.value.filter(
    (_, index) => !assignments.value[index]
  );

  if (unassignedRoutes.length > 0) {
    message.value =
      `"Toutes les tournées doivent être attribuées à un cycliste avant l'enregistrement.\n" +
      Tournées non attribuées : ${unassignedRoutes.map((_, i) => `#${i + 1}`).join(", ")}`;
      showWarn(message)
    return;
  }

  // Préparez les données pour l'enregistrement
  const tournees = formattedRoutes.value.map((route, index) => ({
    id_tournee: index + 1, // ID de la tournée
    date: new Date().toISOString().split('T')[0], // Date actuelle
    utilisateur_id: assignments.value[index], // Cycliste assigné
    etat: 'planifiee', // État initial
    nom: route, // Nom de la tournée
  }));

  const trajets = cyclistRoutes.value.flatMap((route, tourneeIndex) => 
    route.map((station, order) => ({
      tournee_id: tourneeIndex + 1, // Associe à l'ID de la tournée
      id_arret : station.id_arret,
      lat: station.lat,
      lng: station.lng,
      ordre_passage: order + 1, // Ordre de passage
    }))
  );

  try {
    // Enregistrer les tournées
    const tourneeResponse = await axios.post('/api/tournee', { tournees });
    message.value = tourneeResponse.data.message
    showSuccess(message)

    // Enregistrer les trajets
    const trajetResponse = await axios.post('/api/trajet', { trajets });
    message.value = trajetResponse.data.message
    showSuccess(message)
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement:', error);
    message.value = 'Erreur lors de l\'enregistrement.';
    showWarn(message)
  }
  await fetchRecordedRoutes();
};

const showRecordedRoute = async (tourneeId: number) => {
  try {
    const response = await axios.get(`/api/tournee/${tourneeId}/trajets`);
    const stations = response.data.trajets.map((stop: any) => ({
      lat: stop.lat,
      lng: stop.lng,
      nom: stop.nom,
    }));
    if (stations.length === 0) {
      showWarn('Aucun trajet disponible pour cette tournée.');
      return;
    }
    if (!map.value) return;

    // Clear existing markers and lines
    stationMarkers.value.forEach(marker => marker.remove());
    stationMarkers.value = [];
    routeLines.value.forEach(line => line.remove());
    routeLines.value = [];

    // Add new markers and route
    stations.forEach((station: { lat: number; lng: number; nom: any; }) => {
      const marker = L.marker([station.lat, station.lng]).bindPopup(`<b>${station.nom}</b>`);
      marker.addTo(map.value);
      stationMarkers.value.push(marker);
    });
    const routeLine = L.polyline(stations.map((station: { lat: any; lng: any; }) => [station.lat, station.lng]), { color: 'blue' });
    routeLine.addTo(map.value);
    routeLines.value.push(routeLine);

    map.value.fitBounds(routeLine.getBounds());
  } catch (error) {
    console.error('Erreur lors de la récupération du trajet:', error);
    showWarn('Impossible d\'afficher le trajet.');
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


// const showSelectedCyclistRoute = () => {
//   if (!map.value) return;

//   // Effacez les tracés actuels de la carte
//   clearMap();

//   // Vérifiez si un cycliste est sélectionné
//   if (!selectedCyclist.value) return;

//   // Trouvez la route assignée au cycliste sélectionné
//   const assignedRouteEntry = Object.entries(assignments.value).find(
//     ([, cyclistId]) => cyclistId === selectedCyclist.value
//   );

//   if (!assignedRouteEntry) {
//     console.warn("Aucune route assignée à ce cycliste.");
//     return;
//   }

//   const routeIndex = parseInt(assignedRouteEntry[0]); // Obtenez l'index de la route
//   const route = cyclistRoutes.value[routeIndex]; // Récupérez la route correspondante

//   if (!route || route.length === 0) {
//     console.warn("La route assignée est vide.");
//     return;
//   }

//   // Affichez la route sur la carte
//   const routeColor = `hsl(${(360 / cyclistRoutes.value.length) * routeIndex}, 70%, 50%)`;
//   showRouteOnMap(route, routeColor);

//   // Ajoutez un marqueur de départ (optionnel)
//   const bikeIcon = L.icon({
//     iconUrl: '/src/assets/bike.png',
//     iconSize: [32, 32],
//     iconAnchor: [16, 16],
//   });

//   const marker = L.marker([route[0].lat, route[0].lng], { icon: bikeIcon });
//   marker.addTo(map.value);
//   bikeMarkers.value.push(marker);

//   // Animer le vélo sur la route
//   animateBikeAlongRoute(marker, route);
// };



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
  showRecordedRoutes.value = false;
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


  fetchRecordedRoutes();

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