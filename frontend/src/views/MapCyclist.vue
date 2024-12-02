<template>
  <div style="width: 100%; float: right;">
    <div id="map" class="map-container"></div>
    <div class="info-container flex flex-column items-center justify-content-center">
      <!-- Informations sur le trajet -->
      <button @click="startRoute" class="custombutton" :disabled="started">Lancer le trajet</button>
      <div class="route-info flex items-center justify-content-center">
        <p v-if="trajets.length > 0 && currentStopIndex >= 0 && currentStopIndex < trajets.length">
          📏 Distance entre ces points : {{ distance.toFixed(2) }} km - Distance totale parcourue : {{ distanceTotal.toFixed(2) }} km <br /><br />
          ⏱️ Temps estimé : {{ duration.toFixed(2) }} min - Temps total écoulé : {{ durationTotal.toFixed(2) }} min <br /><br />
          🗑️ Capacité de déchets : {{ capacity }}/200 kg -🔋 Autonomie restante : {{ autonomy }} m
        </p>
        <p v-else>Chargement des trajets...</p>
      </div>
      <div class="flex items-center justify-content-center">
        <label>
          <input type="radio" name="winter" value=false v-model="isWinter" checked/>☀️
        </label>
        <label style="margin-left: 10px;">
          <input type="radio" name="winter" value=true v-model="isWinter" />❄️
        </label>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref, computed } from 'vue';
import axios from 'axios';
axios.defaults.baseURL = 'http://localhost:3000';
import L from 'leaflet';
import polyline from '@mapbox/polyline';
import { useToast } from "primevue/usetoast";
import router from '@/router';

const message = ref('');
const toast = useToast();
const map = ref<L.Map>();
const stationMarkers = ref<L.Marker[]>([]);
const routeLines = ref<L.Polyline[]>([]);
const bikeMarker = ref<L.Marker | null>(null);
const trajets = ref<any[]>([]);
let currentStopIndex = 0;
const distance = ref(0);
const distanceTotal = ref(0);
const duration = ref(0);
const durationTotal = ref(0);
let autonomy = ref(50000); // En mètres
let capacity = ref(0); // En kg
const maxCapacity = 200; // Capacité maximale
const isWinter = ref(false);
const started = ref(false);
const utilisateur_id = ref("")
const actualUser = ref(undefined)

async function getActualUser(){
if(localStorage.getItem("token")) {
  try{
    const resp = await axios.get('/api/app', {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
    })
    actualUser.value = resp.data.message
    if(actualUser.value.role == 'gestionnaire_reseau') {
      router.push("/app/map")
    }
    else if(actualUser.value.role == 'RH') {
      router.push("/app/users")
    }
  }
  catch(error) {
    message.value = error.response.data.error
    showWarn(message)
  }
}else{
  router.push("/login")
  }
}

const currentStopName = computed(() => {
  if (trajets.value.length > 0 && currentStopIndex >= 0 && currentStopIndex < trajets.value.length) {
    return trajets.value[currentStopIndex]?.nom || "N/A";
  }
  return "N/A";
});

const nextStopName = computed(() => {
  if (trajets.value.length > 0 && currentStopIndex + 1 < trajets.value.length) {
    return trajets.value[currentStopIndex + 1]?.nom || "Arrivée finale";
  }
  return "Arrivée finale";
});

const updateAutonomyForWinter = () => {
  autonomy.value = isWinter.value ? 45000 : 50000;
};

const clearMarkersAndLines = () => {
  stationMarkers.value.forEach(marker => marker?.remove());
  stationMarkers.value = [];
  routeLines.value.forEach(line => line?.remove());
  routeLines.value = [];
};

const loadUserTourneeTrajets = async () => {
  try {
    const userResponse = await axios.get('/api/app', {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    });
    const user = userResponse.data.message;
    const userId = user.id_utilisateur;
    utilisateur_id.value = user.id_utilisateur;

    const response = await axios.get(`/api/tournee/${userId}/trajet/user`, {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    });

    trajets.value = response.data.trajets;

    currentStopIndex = trajets.value.findIndex((stop) => stop.isDone === 0);
    if (currentStopIndex === -1) currentStopIndex = trajets.value.length - 1;

    if (map.value && trajets.value.length > 0) {
      map.value.setView([trajets.value[currentStopIndex].lat, trajets.value[currentStopIndex].lng], 14);
    }
  } catch (error) {
    console.error('Erreur lors de la récupération des trajets:', error);
  }
};

const fetchRoute = async (start, end) => {
  const url = "http://localhost:8080/ors/v2/directions/cycling-electric";
  const data = {
    coordinates: [
      [start.lng, start.lat],
      [end.lng, end.lat],
    ],
    profile: "cycling-electric",
    instructions: false,
    geometry: true,
  };

  const response = await axios.post(url, data, {
    headers: { "Content-Type": "application/json" },
  });

  const decodedGeometry = polyline.decode(response.data.routes[0].geometry);
  return {
    routeCoordinates: decodedGeometry,
    summary: response.data.routes[0].summary,
  };
};

const displayCurrentStops = async () => {
  if (!map.value) return;
  clearMarkersAndLines();

  const start = trajets.value[currentStopIndex];
  const end = trajets.value[currentStopIndex + 1];

  if (start && end && start.lat === end.lat && start.lng === end.lng) {
    currentStopIndex++;
    await displayCurrentStops();
    return;
  }

  if (start && end && start.lat && start.lng && end.lat && end.lng) {
    const { routeCoordinates, summary } = await fetchRoute(start, end);

    if (routeCoordinates.length > 0) {
      const line = L.polyline(routeCoordinates, { color: 'blue', weight: 3 });
      line.addTo(map.value);
      routeLines.value.push(line);
      map.value.fitBounds(line.getBounds());

      const startMarker = L.marker([start.lat, start.lng]).bindPopup("Départ");
      const endMarker = L.marker([end.lat, end.lng]).bindPopup("Arrivée");
      startMarker.addTo(map.value);
      endMarker.addTo(map.value);
      stationMarkers.value.push(startMarker, endMarker);

      distance.value = summary.distance / 1000;
      duration.value = summary.duration / 60;
      distanceTotal.value += distance.value;
      durationTotal.value += duration.value;

      autonomy.value -= summary.distance;

      if (end.nom !== "Porte d'Ivry") {
        capacity.value = Math.min(capacity.value + 50, maxCapacity);
      } else {
        capacity.value = 0;
        if(isWinter.value === false) {
          autonomy.value = 50000;
        } else {
          autonomy.value = 45000;
        }
      }
    }
  }
};

const showWarn = (message: any) => {
  toast.add({ severity: 'error', summary: "Message d'erreur", detail: message });
};
const showSuccess = (message: any) => {
  toast.add({ severity: 'success', summary: "Succès", detail: message, life: 3000 });
};

const setTourneeEnCours = async () =>{
  console.log(utilisateur_id.value)
  axios.patch(`api/tournee/encours/${utilisateur_id.value}`)
  .then(() => {
      message.value = `Tournée démarré`;
      showSuccess(message)
    })
}

const startRoute = () => {
  updateAutonomyForWinter();
  setTourneeEnCours();

  if (!trajets.value || trajets.value.length < 2) return;

  currentStopIndex = 0;
  started.value = true
  const start = trajets.value[currentStopIndex];
  bikeMarker.value = L.marker([start.lat, start.lng], {
    icon: L.icon({
      iconUrl: '/src/assets/bike.png',
      iconSize: [32, 32],
      iconAnchor: [16, 16],
    }),
  }).addTo(map.value);

  displayCurrentStops();
  moveBikeToNextStop();
};

const moveBikeToNextStop = async () => {
  if (currentStopIndex >= trajets.value.length - 1) {
    console.log("Trajet terminé.");
    return;
  }

  const start = trajets.value[currentStopIndex];
  const end = trajets.value[currentStopIndex + 1];

  if (start.lat === end.lat && start.lng === end.lng) {
    currentStopIndex++;
    await axios.patch(`/api/trajet/${start.id_trajet}`, { isDone: 1 });
    displayCurrentStops();
    moveBikeToNextStop();
    return;
  }

  const { routeCoordinates } = await fetchRoute(start, end);

  let step = 0;
  const steps = routeCoordinates.length;
  const delay = 50;

  const moveBike = () => {
    if (step >= steps) {
      currentStopIndex++;
      axios.patch(`/api/trajet/${start.id_trajet}`, { isDone: 1 });
      displayCurrentStops();
      moveBikeToNextStop();
      return;
    }

    const [lat, lng] = routeCoordinates[step];
    if (bikeMarker.value) {
      bikeMarker.value.setLatLng([lat, lng]);
    }

    step++;
    setTimeout(moveBike, delay);
  };

  moveBike();
};

onMounted(() => {
  getActualUser()
  updateAutonomyForWinter();

  clearMarkersAndLines();
  if (map.value) {
    map.value.remove();
  }

  map.value = L.map('map').setView([48.8511, 2.355], 14);

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 60,
    attribution: '&copy; OpenStreetMap contributors',
  }).addTo(map.value);

  loadUserTourneeTrajets();
});

</script>

<style scoped>
.map-container {
  width: 100%;
  height: 60%;
}

.route-info {
  margin: 10px 0;
  font-size: 14px;
  font-weight: bold;
}

.info-container {
  margin-top: 10px;
}

.custombutton {
  width: 100%;
  float: right;
  margin: 1%;
  padding: 10px 20px;
  background-color: #52422d;
  color: white;
  font-size: 16px;
  font-weight: bold;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.custombutton:hover {
  background-color: #826b48;
}
</style>