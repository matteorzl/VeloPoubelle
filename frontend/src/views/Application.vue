<script setup>
import { ref, onBeforeMount, provide } from 'vue'
import router from '../router/index'
import axios from 'axios'
import Sidebar from '../components/sidebar/Sidebar.vue'

axios.defaults.baseURL = "http://localhost:3000"

const isLoading = ref(true)
const user = ref(undefined)
const menu = 2

// Créer la référence isNavVisible pour contrôler la visibilité de la sidebar
const isNavVisible = ref(false)
console.log(localStorage.getItem("token"))

// Fournir isNavVisible pour le rendre disponible aux composants enfants
provide('isNavVisible', isNavVisible)

async function getUser(){
  if(localStorage.getItem("token")) {
    try{
      const resp = await axios.get('/api/app', {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
      })
      user.value = resp.data.message
      isLoading.value = false
    }
    catch(error) {
      console.error('Error fetching user data:', error)
    }
  }else{
    router.push("/login")
    isLoading.value = false
    }
  }
onBeforeMount(() => {
  getUser()
})
</script>

<template>
    <div v-if="isLoading">
      <ProgressSpinner style="width: 100px; height: 100px;top:50%;left:47%;margin-top: 20%;" />
      <p style="text-align: center; font-size: large;">Chargement des données utilisateur...</p>
    </div>
    <div v-else>
    <div :class="{ 'content-shifted': isNavVisible }">
      <Sidebar :id="user?.id_utilisateur" :nom="user?.nom" :prenom="user?.prenom" :role="user?.role" />
      <div class="flex items-center justify-center h-screen" style="background-color: #e4dfd0 !important;">
        <router-view />
      </div>
    </div>
  </div>
</template>

<style>
.content-shifted {
  padding-left: calc(var(--nav-width) + 156px);
  transition: .5s;
}
</style>