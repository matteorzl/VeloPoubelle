<script setup>
  import { MapboxMap, MapboxMarker } from '@studiometa/vue-mapbox-gl';
</script>

<template>
  <MapboxMap
    style="height: 400px"
    access-token="pk.eyJ1IjoibWF0dGVvYXJ6ZWwiLCJhIjoiY20zZWt1dnd4MDl6eDJpc2VzNnpqcGx5bCJ9.Ew8RiT2EwBv9O8n_rQhbCA"
    map-style="mapbox://styles/mapbox/streets-v11">
    <MapboxMarker :lng-lat="[0, 0]" />
  </MapboxMap>
</template>
