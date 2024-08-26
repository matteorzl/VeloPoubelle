<script setup>
import { ref, onMounted } from 'vue'
import router from '../router/index'
import axios from 'axios';
axios.defaults.baseURL = "http://localhost:3000"

if (localStorage.getItem("token") === null) {
    router.push("/login")
}

const isLoading = ref(true);
const user = ref(undefined)

async function getUser(){
  try{
    const resp = await axios.get('/api/app', {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
    })
    user.value = resp.data.message;
    isLoading.value = false;
  }
  catch(error) {
    console.error('Error fetching user data:', error);
  };
}
 
onMounted(() => {
  getUser()
});
  
if (localStorage.getItem("token") === null) {
  router.push("/login")
}
</script>

<template>
  <div v-if="isLoading" >
    <ProgressSpinner style="width: 100px; height: 100px;top:50%;left:47%;margin-top: 20%;" strokeWidth="8" fill="transparent" animationDuration=".5s" aria-label="Custom ProgressSpinner"/>
    <p style="text-align: center; font-size: large;">Chargement des données utilisateur...</p>
  </div>
  <div v-else>
    <Sidebar :nom="user?.nom" :prenom="user?.prenom" :role="user?.role" />
    <div style="background-color: #52422d !important; width: 900px; height: 1244px; margin-left: 25%; margin-top: 1%;border-radius:2em"></div>
  </div>
</template>
