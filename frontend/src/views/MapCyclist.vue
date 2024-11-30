<template>
  <div style="width: 100%; float: right;">
    <div id="map" class="map-container"></div>
    <div style="margin-top: 10px;">
      <!-- Informations sur le trajet -->
      <div class="route-info">
        <p v-if="trajets.length > 0">
          Étape : {{ currentStopIndex + 1 }}/{{ trajets.length }} <br />
          Départ : <strong>{{ currentStopName }}</strong> → Arrivée : <strong>{{ nextStopName }}</strong>
        </p>
        <p v-else>Chargement des trajets...</p>
      </div>
      <button @click="startRoute" class="custombutton">Lancer le trajet</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref, computed } from 'vue';
import axios from 'axios';
import L from 'leaflet';

const map = ref<L.Map>();
const stationMarkers = ref<L.Marker[]>([]);
const routeLines = ref<L.Polyline[]>([]);
const bikeMarker = ref<L.Marker | null>(null);
const trajets = ref<any[]>([]);
let currentStopIndex = 0;

// Variables calculées pour afficher les noms des arrêts
const currentStopName = computed(() => trajets.value[currentStopIndex]?.nom || "N/A");
const nextStopName = computed(() => trajets.value[currentStopIndex + 1]?.nom || "N/A");

// Nettoyer les marqueurs et lignes visibles
const clearMarkersAndLines = () => {
  stationMarkers.value.forEach(marker => marker.remove());
  stationMarkers.value = [];
  routeLines.value.forEach(line => line.remove());
  routeLines.value = [];
};

const loadUserTourneeTrajets = async () => {
  try {
    const userResponse = await axios.get('/api/app', {
      headers: {
        Authorization: `Bearer ${localStorage.getItem('token')}`,
      },
    });

    const user = userResponse.data.message;
    const userId = user.id_utilisateur;

    const response = await axios.get(`/api/tournee/${userId}/trajets`, {
      headers: {
        Authorization: `Bearer ${localStorage.getItem('token')}`,
      },
    });

    trajets.value = response.data.trajets;
    console.log("Trajets reçus :", trajets.value);

    // Trouvez l'indice du prochain trajet non terminé
    currentStopIndex = trajets.value.findIndex((stop) => stop.isDone === 0);

    if (currentStopIndex === -1) {
      console.log("Tous les trajets sont terminés.");
      currentStopIndex = trajets.value.length - 1;
    }

    if (map.value && trajets.value.length > 0) {
      map.value.setView([trajets.value[currentStopIndex].lat, trajets.value[currentStopIndex].lng], 14);
    }
  } catch (error) {
    console.error('Erreur lors de la récupération des trajets:', error);
  }
};


// Fonction pour afficher les arrêts passés et le trajet en cours
const displayCurrentStops = () => {
  if (!map.value) return;

  clearMarkersAndLines();

  const passedStops = trajets.value.filter((stop, index) => index < currentStopIndex);
  passedStops.forEach((stop, index) => {
    if (stop.lat && stop.lng) {
      const marker = L.marker([stop.lat, stop.lng], {
        icon: L.icon({
          iconUrl: '/src/assets/passed-marker.png',
          iconSize: [16, 16],
        }),
      }).bindTooltip(`<b>Arrêt ${index + 1}/${trajets.value.length}: ${stop.nom}</b>`, {
        permanent: true,
        direction: 'right',
      });
      marker.addTo(map.value);
      stationMarkers.value.push(marker);
    }
  });

  if (currentStopIndex < trajets.value.length - 1) {
    const start = trajets.value[currentStopIndex];
    const end = trajets.value[currentStopIndex + 1];

    if (start.lat === end.lat && start.lng === end.lng) {
      console.log("Départ et arrivée sont identiques pour cet étape, aucun trajet affiché.");
      return;
    }

    if (start.lat && start.lng) {
      const startMarker = L.marker([start.lat, start.lng])
        .bindTooltip(`<b>Départ (Étape ${currentStopIndex + 1}/${trajets.value.length}): ${start.nom}</b>`, {
          permanent: true,
          direction: 'top',
        });
      startMarker.addTo(map.value);
      stationMarkers.value.push(startMarker);
    }

    if (end.lat && end.lng) {
      const endMarker = L.marker([end.lat, end.lng])
        .bindTooltip(`<b>Arrivée (Étape ${currentStopIndex + 2}/${trajets.value.length}): ${end.nom}</b>`, {
          permanent: true,
          direction: 'top',
        });
      endMarker.addTo(map.value);
      stationMarkers.value.push(endMarker);
    }

    if (start.lat && start.lng && end.lat && end.lng) {
      const line = L.polyline(
        [
          [start.lat, start.lng],
          [end.lat, end.lng],
        ],
        { color: 'blue', weight: 3 }
      );
      line.addTo(map.value);
      routeLines.value.push(line);

      map.value.fitBounds([
        [start.lat, start.lng],
        [end.lat, end.lng],
      ]);
    }
  }
};


const startRoute = () => {
  if (!trajets.value || trajets.value.length < 2) return;

  currentStopIndex = 0;

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
  if (!trajets.value || currentStopIndex >= trajets.value.length - 1) {
    console.log("Trajet terminé.");
    return;
  }

  const start = trajets.value[currentStopIndex];
  const end = trajets.value[currentStopIndex + 1];

  // Vérifiez si `id_trajet` est présent
  if (!start.hasOwnProperty('id_trajet') || start.id_trajet === undefined) {
    console.warn('id_trajet manquant pour le point de départ:', start);
    return;
  }

  // Si le point de départ est identique au point d'arrivée
  if (start.lat === end.lat && start.lng === end.lng) {
    console.log(`Étape ignorée car départ et arrivée sont identiques (id_trajet: ${start.id_trajet})`);
    
    // Marquer cette étape comme terminée
    await axios
      .patch(`/api/trajet/${start.id_trajet}`, { isDone: 1 })
      .then(() => console.log(`Trajet ${start.id_trajet} marqué comme terminé.`))
      .catch(console.error);

    currentStopIndex++;
    displayCurrentStops(); // Mettre à jour la carte
    moveBikeToNextStop(); // Passer au trajet suivant
    return;
  }

  // Utiliser une distance fixe de 500m pour le mouvement
  const distance = 500;
  const speed = 2000;
  const time = (distance / 1000) / speed * 3600;

  const steps = 100;
  let step = 0;
  const delay = (time * 1000) / steps;

  const moveBike = () => {
    if (step >= steps) {
      currentStopIndex++;
      axios
        .patch(`/api/trajet/${start.id_trajet}`, { isDone: 1 })
        .then(() => console.log(`Trajet ${start.id_trajet} marqué comme terminé.`))
        .catch(console.error);

      displayCurrentStops();
      moveBikeToNextStop();
      return;
    }

    const lat = start.lat + ((end.lat - start.lat) * step) / steps;
    const lng = start.lng + ((end.lng - start.lng) * step) / steps;

    if (bikeMarker.value) {
      bikeMarker.value.setLatLng([lat, lng]);
    }
    step++;
    setTimeout(moveBike, delay);
  };

  moveBike();
};

onMounted(() => {
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
  height: 80%;
}

.route-info {
  margin: 10px 0;
  font-size: 14px;
  font-weight: bold;
}
</style>
