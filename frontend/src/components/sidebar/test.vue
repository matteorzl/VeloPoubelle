<script setup>
import { ref, defineProps } from 'vue'
import { resolveModuleName } from 'typescript';
import router from '../../router/index';

const props = defineProps({
nom: {
    type: String,
    required: false,
    default: ''
},
prenom: {
    type: String,
    required: false,
    default: ''
},
role: {
    type: String,
    required: false,
    default: ''
}
})

async function logout() {
localStorage.removeItem('token');
window.location.reload();

}

// Déclarez une référence réactive pour contrôler la visibilité de la navbar
const isNavVisible = ref(false)

// Fonction pour basculer la navbar
const toggleNavbar = () => {
  isNavVisible.value = !isNavVisible.value
}
</script>

<template>
  <body :class="{ 'body-pd': isNavVisible }" id="body-pd">
    <header :class="{ 'body-pd': isNavVisible }" class="header" id="header">
      <div class="header_toggle" @click="toggleNavbar">
        <!-- Change l'icône en fonction de l'état de la navbar -->
        <i :class="isNavVisible ? 'bx bx-x' : 'bx bx-menu'" id="header-toggle"></i>
      </div>
      <div class="header_img">
            <img id="nav-title" target="_blank" src="./../../assets/logo_white.png" width="200px"/>
      </div>
    </header>

    <!-- Ajoute ou enlève la classe 'show' selon l'état de visibilité -->
    <div :class="['l-navbar', { show: isNavVisible }]" id="nav-bar">
      <nav class="nav">
        <a href="#" class="nav_logo">
            <i class="bx bx-layer nav_logo-icon"></i>
            <span class="nav_logo-name">BikeBags</span>
        </a>
        <div v-if="role == 'cycliste'">
            <div class="nav_list">
                <a href="#" class="nav_link active">
                <i class="bx bx-cycling"></i>
                <span class="nav_name">Mon trajet</span>
                </a>
                <a href="/users" class="nav_link">
                <i class="bx bx-user nav_icon"></i>
                <span class="nav_name">Utilisateurs</span>
                </a>
            </div>
        </div>
        <a href="#" class="nav_link">
        <i class="bx bx-log-out nav_icon"></i>
        <span class="nav_name">Se déconnecter</span>
        </a>
      </nav>
    </div>

    <!-- Contenu principal -->
    <div class="height-100 bg-light">
      <h4>Main Components</h4>
    </div>
  </body>
</template>

<style>
/* Ajoutez votre style ici, inchangé */
@import url("https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap");
:root {
  --header-height: 3rem;
  --nav-width: 68px;
  --first-color: #826b48;
  --first-color-light: #52422d;
  --white-color: #F7F6FB;
  --body-font: 'Nunito', sans-serif;
  --normal-font-size: 1rem;
  --z-fixed: 100;
}
*, ::before, ::after {
  box-sizing: border-box;
}
body {
  position: relative;
  margin: var(--header-height) 0 0 0;
  padding: 0 1rem;
  font-family: var(--body-font);
  font-size: var(--normal-font-size);
  transition: .5s;
}
a {
  text-decoration: none;
}
.header {
  width: 100%;
  height: var(--header-height);
  position: fixed;
  top: 0;
  left: 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 1rem;
  background-color: var(--white-color);
  z-index: var(--z-fixed);
  transition: .5s;
}
.header_toggle {
  color: var(--first-color);
  font-size: 1.5rem;
  cursor: pointer;
}
.header_img {
  width: 35px;
  height: 35px;
  display: flex;
  justify-content: center;
  border-radius: 50%;
  overflow: hidden;
}
.header_img img {
  width: 40px;
}
.l-navbar {
  position: fixed;
  top: 0;
  left: -30%;
  width: var(--nav-width);
  height: 100vh;
  background-color: var(--first-color);
  padding: .5rem 1rem 0 0;
  transition: .5s;
  z-index: var(--z-fixed);
}
.nav {
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  overflow: hidden;
}
.nav_logo,
.nav_link {
  display: grid;
  grid-template-columns: max-content max-content;
  align-items: center;
  column-gap: 1rem;
  padding: .5rem 0 .5rem 1.5rem;
}
.nav_logo {
  margin-bottom: 2rem;
}
.nav_logo-icon {
  font-size: 1.25rem;
  color: var(--white-color);
}
.nav_logo-name {
  color: var(--white-color);
  font-weight: 700;
}
.nav_link {
  position: relative;
  color: var(--white-color);
  margin-bottom: 1.5rem;
  transition: .3s;
}
.nav_link:hover {
  color: var(--white-color);
}
.nav_icon {
  font-size: 1.25rem;
}
.show {
  left: 0;
}
.body-pd {
  padding-left: calc(var(--nav-width) + 1rem);
}
.active {
  color: var(--white-color);
}
.active::before {
  content: '';
  position: absolute;
  left: 0;
  width: 2px;
  height: 32px;
  background-color: var(--white-color);
}
.height-100 {
  height: 100vh;
}
@media screen and (min-width: 768px) {
  body {
    margin: calc(var(--header-height) + 1rem) 0 0 0;
    padding-left: calc(var(--nav-width) + 2rem);
  }
  .header {
    height: calc(var(--header-height) + 1rem);
    padding: 0 2rem 0 calc(var(--nav-width) + 2rem);
  }
  .header_img {
    width: 40px;
    height: 40px;
  }
  .header_img img {
    width: 45px;
  }
  .l-navbar {
    left: 0;
    padding: 1rem 1rem 0 0;
  }
  .show {
    width: calc(var(--nav-width) + 156px);
  }
  .body-pd {
    padding-left: calc(var(--nav-width) + 188px);
  }
}
</style>
