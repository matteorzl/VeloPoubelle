<script setup>
import { resolveModuleName } from 'typescript';
import router from '../../router/index';
import { defineProps} from 'vue';

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
</script>

<template>
    <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css'><link rel="stylesheet" href="./style.css">
    <div id="nav-bar">
        <input id="nav-toggle" type="checkbox"/>
        <div id="nav-header">
            <img id="nav-title" target="_blank" src="./../../assets/logo_white.png" width="200px"/>
            <label for="nav-toggle"><span id="nav-toggle-burger"></span></label>
            <hr/>
        </div>

        <!-- Si role est cycliste -->
        <div v-if="role == 'cycliste'">
          <div  id="nav-content" class="font-bold">
              <div class="nav-button"><i class="fas fa-bicycle"></i><span to="/graph">Mon trajet</span></div>
              <div id="nav-content-highlight"></div>
          </div>
          <div  id="nav-content" class="font-bold">
              <router-link :to="{ path: '/users'}" class="nav-button"><i class="fas fa-bicycle"></i><span>Utilisateurs</span></router-link>
              <div id="nav-content-highlight"></div>
          </div>
        </div>

        <!-- Si role est rh -->
        <div v-if="role == 'rh'">
          <div  id="nav-content" class="font-bold">
              <div class="nav-button"><i class="fas fa-bicycle"></i><span to="/graph">Ajouter</span></div>
              <div id="nav-content-highlight"></div>
          </div>
          <div  id="nav-content" class="font-bold">
              <div class="nav-button"><i class="fas fa-bicycle"></i><span to="/graph">Modifier</span></div>
              <div id="nav-content-highlight"></div>
          </div>
        </div>

        <!-- Si role est admin -->
        <div v-if="role == 'admin'">
          <div  id="nav-content" class="font-bold">
              <div class="nav-button"><i class="fas fa-bicycle"></i><span to="/graph">Cyclistes</span></div>
              <div id="nav-content-highlight"></div>
          </div>
          <div  id="nav-content" class="font-bold">
              <div class="nav-button"><i class="fas fa-bicycle"></i><span to="/graph">RHs</span></div>
              <div id="nav-content-highlight"></div>
          </div>
          <div  id="nav-content" class="font-bold">
              <div class="nav-button"><i class="fas fa-bicycle"></i><span to="/graph">Gestionnaires</span></div>
              <div id="nav-content-highlight"></div>
          </div>
        </div>


        <!-- Si role est gestionnaire -->
        <div v-if="role == 'gestionnaire'">
          <div  id="nav-content" class="font-bold">
              <div class="nav-button"><i class="fas fa-bicycle"></i><span to="/graph">Tournées</span></div>
              <div id="nav-content-highlight"></div>
          </div>
          <div  id="nav-content" class="font-bold">
              <div class="nav-button"><i class="fas fa-bicycle"></i><span to="/graph">Incidents</span></div>
              <div id="nav-content-highlight"></div>
          </div>
          <div  id="nav-content" class="font-bold">
              <div class="nav-button"><i class="fas fa-bicycle"></i><span to="/graph">Voir les rues</span></div>
              <div id="nav-content-highlight"></div>
          </div>
        </div>

        <input id="nav-footer-toggle" type="checkbox"/>
        <div id="nav-footer" class="font-bold">
            <div id="nav-footer-heading">
            <div id="nav-footer-avatar"><i class="fas fa-user"></i></div>
            <div id="nav-footer-titlebox"><a id="nav-footer-title" href="https://codepen.io/uahnbu/pens/public" target="_blank">{{prenom + " " +nom}}</a><span id="nav-footer-subtitle">{{ role }}</span></div>
            <label for="nav-footer-toggle"><i class="fas fa-caret-up"></i></label>
            </div>
            <div id="nav-footer-content">
              <button class="logout-button" @click="logout">Déconnexion</button>
            </div>
        </div>
    </div>
</template>


<style lang="scss">
  @import "sidebar.sass";

  :root {
  --background: #e4dfd0;
  --navbar-width: 256px;
  --navbar-width-min: 80px;
  --navbar-dark-primary: #826b48;
  --navbar-dark-secondary: #52422d;
  --navbar-light-primary: #52422d;
  --navbar-light-secondary: #52422d;
}

html, body {
  margin: 0;
  background: var(--background);
}

#nav-toggle:checked ~ #nav-header {
  width: calc(var(--navbar-width-min) - 16px);
}
#nav-toggle:checked ~ #nav-content, #nav-toggle:checked ~ #nav-footer {
  width: var(--navbar-width-min);
}
#nav-toggle:checked ~ #nav-header #nav-title {
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.1s;
}
#nav-toggle:checked ~ #nav-header label[for=nav-toggle] {
  left: calc(50% - 8px);
  transform: translate(-50%);
}
#nav-toggle:checked ~ #nav-header #nav-toggle-burger {
  background: var(--navbar-light-primary);
}
#nav-toggle:checked ~ #nav-header #nav-toggle-burger:before, #nav-toggle:checked ~ #nav-header #nav-toggle-burger::after {
  width: 16px;
  background: var(--navbar-light-secondary);
  transform: translate(0, 0) rotate(0deg);
}
#nav-toggle:checked ~ #nav-content .nav-button span {
  opacity: 0;
  transition: opacity 0.1s;
}
#nav-toggle:checked ~ #nav-content .nav-button .fas {
  min-width: calc(100% - 16px);
}
#nav-toggle:checked ~ #nav-footer #nav-footer-avatar {
  margin-left: 0;
  left: 50%;
  transform: translate(-50%);
}
#nav-toggle:checked ~ #nav-footer #nav-footer-titlebox, #nav-toggle:checked ~ #nav-footer label[for=nav-footer-toggle] {
  opacity: 0;
  transition: opacity 0.1s;
  pointer-events: none;
}

#nav-bar {
  position: absolute;
  left: 1vw;
  top: 1vw;
  height: calc(100% - 2vw);
  background: var(--navbar-dark-primary);
  border-radius: 16px;
  display: flex;
  flex-direction: column;
  color: var(--navbar-light-primary);
  font-family: Verdana, Geneva, Tahoma, sans-serif;
  overflow: hidden;
  user-select: none;
}
#nav-bar hr {
  margin: 0;
  position: relative;
  left: 16px;
  width: calc(100% - 32px);
  border: none;
  border-top: solid 1px var(--navbar-dark-secondary);
}
#nav-bar a {
  color: inherit;
  text-decoration: inherit;
}
#nav-bar input[type=checkbox] {
  display: none;
}

#nav-header {
  position: relative;
  width: var(--navbar-width);
  left: 16px;
  width: calc(var(--navbar-width) - 16px);
  min-height: 80px;
  background: var(--navbar-dark-primary);
  border-radius: 16px;
  z-index: 2;
  display: flex;
  align-items: center;
  transition: width 0.2s;
}
#nav-header hr {
  position: absolute;
  bottom: 0;
}

#nav-title {
  font-size: 1.5rem;
  transition: opacity 1s;
}

label[for=nav-toggle] {
  position: absolute;
  right: 0;
  width: 3rem;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

#nav-toggle-burger {
  position: relative;
  width: 16px;
  height: 2px;
  background: var(--navbar-dark-primary);
  border-radius: 99px;
  transition: background 0.2s;
}
#nav-toggle-burger:before, #nav-toggle-burger:after {
  content: "";
  position: absolute;
  top: -6px;
  width: 10px;
  height: 2px;
  background: var(--navbar-light-primary);
  border-radius: 99px;
  transform: translate(2px, 8px) rotate(30deg);
  transition: 0.2s;
}
#nav-toggle-burger:after {
  top: 6px;
  transform: translate(2px, -8px) rotate(-30deg);
}

#nav-content {
  margin: -16px 0;
  padding: 16px 0;
  position: relative;
  flex: 1;
  width: var(--navbar-width);
  background: var(--navbar-dark-primary);
  box-shadow: 0 0 0 16px var(--navbar-dark-primary);
  direction: rtl;
  overflow-x: hidden;
  transition: width 0.2s;
}
#nav-content::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}
#nav-content::-webkit-scrollbar-thumb {
  border-radius: 99px;
  background-color: var(--navbar-dark-secondary);
}

#nav-content-highlight {
  position: absolute;
  left: 16px;
  top: -70px;
  height: 54px;
  background: var(--background);
  background-attachment: fixed;
  border-radius: 16px 0 0 16px;
  transition: top 0.2s;
}
#nav-content-highlight:before, #nav-content-highlight:after {
  content: "";
  position: absolute;
  right: 0;
  bottom: 100%;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  box-shadow: 16px 16px var(--background);
}
#nav-content-highlight:after {
  top: 100%;
  box-shadow: 16px -16px var(--background);
}

.logout-button{
  color: var(--navbar-light-primary);
  background-color: var(--navbar-dark-primary);
  border-radius: 5em;
  padding: 1px 0px 10px 0px;
  width: 100%;
  height: 100%;
}
.logout-button:hover{
  background-color: var(--background);
}

.nav-button {
  position: relative;
  margin-left: 16px;
  height: 54px;
  display: flex;
  align-items: center;
  color: var(--navbar-light-secondary);
  direction: ltr;
  cursor: pointer;
  z-index: 1;
  transition: color 0.2s;
}
.nav-button span {
  transition: opacity 1s;
}
.nav-button .fas {
  transition: min-width 0.2s;
}
.nav-button:nth-of-type(1):hover {
  color: var(--navbar-dark-primary);
}
.nav-button:nth-of-type(1):hover ~ #nav-content-highlight {
  top: 16px;
}
.nav-button:nth-of-type(2):hover {
  color: var(--navbar-dark-primary);
}
.nav-button:nth-of-type(2):hover ~ #nav-content-highlight {
  top: 70px;
}
.nav-button:nth-of-type(3):hover {
  color: var(--navbar-dark-primary);
}
.nav-button:nth-of-type(3):hover ~ #nav-content-highlight {
  top: 124px;
}
.nav-button:nth-of-type(4):hover {
  color: var(--navbar-dark-primary);
}
.nav-button:nth-of-type(4):hover ~ #nav-content-highlight {
  top: 178px;
}
.nav-button:nth-of-type(5):hover {
  color: var(--navbar-dark-primary);
}
.nav-button:nth-of-type(5):hover ~ #nav-content-highlight {
  top: 232px;
}
.nav-button:nth-of-type(6):hover {
  color: var(--navbar-dark-primary);
}
.nav-button:nth-of-type(6):hover ~ #nav-content-highlight {
  top: 286px;
}
.nav-button:nth-of-type(7):hover {
  color: var(--navbar-dark-primary);
}
.nav-button:nth-of-type(7):hover ~ #nav-content-highlight {
  top: 340px;
}
.nav-button:nth-of-type(8):hover {
  color: var(--navbar-dark-primary);
}
.nav-button:nth-of-type(8):hover ~ #nav-content-highlight {
  top: 394px;
}

#nav-bar .fas {
  min-width: 3rem;
  text-align: center;
}

#nav-footer {
  bottom: 0;
  position: fixed;
  width: var(--navbar-width);
  height: 54px;
  background: var(--navbar-dark-secondary);
  color: var(--navbar-dark-primary);
  border-radius: 16px;
  display: flex;
  flex-direction: column;
  z-index: 2;
  transition: width 0.2s, height 0.2s;
}

#nav-footer-heading {
  position: relative;
  width: 100%;
  height: 60px;
  display: flex;
  align-items: center;
}

#nav-footer-avatar {
  color: var(--navbar-dark-primary);
  position: relative;
  margin: 11px 0 5px 5px;
  left: 0;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  overflow: hidden;
  transform: translate(0);
  padding-right:2.5em;
  transition: 0.2s;
}
#nav-footer-avatar i {
  height: 100%;
}

#nav-footer-titlebox {
  position: relative;
  margin-left: 16px;
  width: 100%;
  display: flex;
  flex-direction: column;
  transition: opacity 1s;
}

#nav-footer-subtitle {
  color: var(--navbar-dark-primary);
  font-size: 0.6rem;
}

#nav-footer-toggle:checked + #nav-footer {
  height: 10%;
  min-height: 54px;
}
#nav-footer-toggle:checked + #nav-footer label[for=nav-footer-toggle] {
  transform: rotate(180deg);
}

label[for=nav-footer-toggle] {
  position: absolute;
  right: 0;
  width: 3rem;
  height: 100%;
  display: flex;
  align-items: center;
  cursor: pointer;
  transition: transform 0.2s, opacity 0.2s;
}

#nav-footer-content {
  margin: 0 16px 16px 16px;
  border-top: solid 1px var(--navbar-dark-primary);
  color: var(--navbar-dark-primary);
  font-size: 1rem;
}
#nav-footer-content::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}
#nav-footer-content::-webkit-scrollbar-thumb {
  border-radius: 99px;
  background-color: var(--navbar-dark-primary);
}
</style>