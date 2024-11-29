<template>
    <div style="width: 100%; float: right;">
      <div id="map" class="map-container"></div>
    </div>
  </template>

<script setup lang="ts">
import { onMounted, ref } from 'vue';
import L from 'leaflet';

const map = ref<L.Map>();

onMounted(() => {

map.value = L.map('map').setView([48.8511, 2.355], 14);

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {

  maxZoom: 60,

  attribution: '&copy; OpenStreetMap contributors'

}).addTo(map.value);

});
</script>

<style scoped>

.map-container {

  width: 100%;

  height: 100%;

}
</style>