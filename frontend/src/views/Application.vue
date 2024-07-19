<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios';
axios.defaults.baseURL = "http://localhost:3000"

let user = ref(undefined)

onMounted(() => {
  axios.get('/api/app', {
    headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
  })
  .then(res => {  
    user.value = res.data.message;
  })
  .catch(error => {
    console.error('Error fetching user data:', error);
  });
})
</script>

<template>
    <div>
        <Sidebar :nom="user?.nom" :prenom="user?.prenom"/>
        <div style="background-color: black !important; width: 900px; height: 1244px; margin-left: 25%; margin-top: 1%"></div>
    </div>
</template>