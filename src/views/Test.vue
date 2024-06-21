<template>
    <div>
        <div v-if="error">Erreur: {{ error }}</div>
        <div v-if="!error && !utilisateurs.length">
            <ProgressSpinner strokeWidth="8" />
        </div>
        <ul v-if="utilisateurs.length">
            <li v-for="utilisateur in utilisateurs" :key="utilisateur.id_utilisateur">
            Nom : {{ utilisateur.nom }} Prenom : {{ utilisateur.prenom }}
            </li>
        </ul>
    </div>
</template>
  
<script setup>
  import { ref, onMounted } from 'vue';
  import axios from 'axios';
  
  const utilisateurs = ref([]);
  const error = ref(null);
  
  onMounted(async () => {
    try {
      const response = await axios.get('http://localhost:3000/api/utilisateurs');
      utilisateurs.value = response.data;
    } catch (err) {
      error.value = err.message;
    }
  });
</script>

<style>
.p-progress-spinner {
  .p-progress-spinner-color {
    stroke: yellow !important;
  }

  @keyframes p-progress-spinner-color {
    100%,
    0% {
      stroke: yellow !important;
    }
    40% {
      stroke: yellow !important;
    }
    66% {
      stroke: yellow !important;
    }
    80%,
    90% {
      stroke: yellow !important;
    }
  }
}
  </style>