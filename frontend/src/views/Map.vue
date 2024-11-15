<template>
  <div style="width: 100%; float: right;">
    <div style="margin: 5%">
    </div>
    <div id="map" class="map-container"></div>
  </div>
</template>

<script>
import { onMounted, ref } from 'vue';
import L from 'leaflet';

export default {
  name: 'MetroMap',
  setup() {
    const map = ref(null);
    const routeOptions = ref([
      { name: 'Alsace-Lorraine', file: 'AlsaceLorraine.json' },
      { name: 'Arts', file: 'Arts.json' },
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
      { name: 'Velane', file: 'Velane.json' },
    ]);

    // Charger toutes les routes et les afficher
    const loadRoute = async (file) => {
      try {
        const response = await fetch(`/src/components/map/${file}`);
        const data = await response.json();

        if (data.stations && data.stations.length > 0) {
          const coords = data.stations.map(station => [station.lat, station.lng]);

          // Ajouter les markers pour les stations
          data.stations.forEach(station => {
            L.marker([station.lat, station.lng]).addTo(map.value)
              .bindPopup(`<b>${station.name}</b>`);
          });

          // Ajouter la polyline pour l'itinéraire
          L.polyline(coords, { color: 'blue' }).addTo(map.value);
        }
      } catch (error) {
        console.error('Erreur lors du chargement de l\'itinéraire:', error);
      }
    };

    // Mettre à jour la carte avec les points de métro
    const updateMap = () => {
      if (map.value) {
        map.value.eachLayer((layer) => {
          if (layer instanceof L.Marker || layer instanceof L.Polyline) {
            map.value.removeLayer(layer);
          }
        });

        const coords = metroStations.value.map(station => [station.lat, station.lng]);
        metroStations.value.forEach(station => {
          L.marker([station.lat, station.lng]).addTo(map.value)
            .bindPopup(`<b>${station.name}</b>`);
        });

        L.polyline(coords, { color: 'blue' }).addTo(map.value);
      }
    };

    // Initialiser le marqueur de vélo
    const initBikeMarker = () => {
      // Si un marqueur de vélo existe déjà, le retirer avant d'en ajouter un nouveau
      if (bikeMarker.value) {
        console.log(map.value)
        map.value.removeLayer(bikeMarker);
      }

      const bikeIcon = L.icon({
        iconUrl: '/src/assets/bike.png', // Remplacez par le chemin de l'image du vélo
        iconSize: [32, 32],
        iconAnchor: [16, 16],
      });
      bikeMarker.value = L.marker([metroStations.value[0].lat, metroStations.value[0].lng], { icon: bikeIcon }).addTo(map.value);
    };

    // Animer le marqueur le long des waypoints
    const animateBikeAlongRoute = () => {
      if (!metroStations.value.length) return;

      initBikeMarker(); // Initialiser le marqueur de vélo au premier waypoint

      let index = 0;
      const steps = 100; // Nombre de sous-étapes entre chaque arrêt
      const delay = 90 * 1000 / steps; // Délai en millisecondes pour chaque sous-étape

      const moveBike = () => {
        if (index >= metroStations.value.length - 1) return;

        const start = metroStations.value[index];
        const end = metroStations.value[index + 1];
        let step = 0;

        const animateStep = () => {
          if (step > steps) {
            index++;
            moveBike();
            return;
          }

          const lat = start.lat + ((end.lat - start.lat) * step) / steps;
          const lng = start.lng + ((end.lng - start.lng) * step) / steps;

          bikeMarker.value.setLatLng([lat, lng]);
          step++;
          setTimeout(animateStep, delay);
        };

        animateStep();
      };

      moveBike();
    };

    // Gérer le changement d'itinéraire dans le Select
    const onRouteChange = async () => {
      if (selectedRoute.value) {
        // Réinitialiser l'animation et le vélo
        if (bikeMarker.value) {
          map.value.removeLayer(bikeMarker.value); // Supprimer l'ancien vélo
        }
        await loadRoute(selectedRoute.value.file);
      }
    };

    // Initialiser la carte
    onMounted(() => {
      // Créer la carte et définir un zoom de départ (par exemple 13)
      map.value = L.map('map').setView([48.8695, 2.4031], 13);

      // Ajouter le fond de carte (tuiles OpenStreetMap)
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 18,
        attribution: 'Map data &copy; <a href="https://openstreetmap.org">OpenStreetMap</a> contributors'
      }).addTo(map.value);

      // Charger toutes les routes et les afficher
      routeOptions.value.forEach(route => {
        loadRoute(route.file);
      });
    });

    return {
      routeOptions
    };
  }
};
</script>


<style scoped>
.map-container {
  width: 100%;
  height: 500px;
}

.route-list {
  list-style-type: none;
  padding: 0;
}

.route-list li {
  padding: 10px;
  cursor: pointer;
  border-bottom: 1px solid #ddd;
}

.route-list li.selected {
  background-color: #007bff;
  color: white;
}

.route-list li:hover {
  background-color: #f0f0f0;
}

.custominput {
  background-color: #826b48 !important;
  border: none !important;
  margin-bottom: 1em;
  color: white !important;
}
</style>

