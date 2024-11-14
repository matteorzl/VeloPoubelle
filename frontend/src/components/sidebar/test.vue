<script setup>
import { color } from 'chart.js/helpers';
import { ref,defineProps, inject } from 'vue'
import axios from 'axios';
axios.defaults.baseURL = 'http://localhost:3000';
import { useRouter } from 'vue-router'
import { useToast } from "primevue/usetoast";

const toast = useToast();
const showDialogModifyPwd = ref(false);
const visible = ref(false);
const ancienPwd = ref('');
const newPwd = ref('');
const confirmPwd = ref('');
const message = ref(null);

const props = defineProps({
  id: {
      type: Number,
      required: false,
      default: null
  },
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

const logout = () => {
  localStorage.removeItem('token')
  window.location.reload()
}

// Injecter isNavVisible depuis Application.vue
const isNavVisible = inject('isNavVisible')

// Fonction pour basculer l'état de la navbar
const toggleNavbar = () => {
  if (isNavVisible) isNavVisible.value = !isNavVisible.value
}

const modifyPwd = () => {
    visible.value = true;
    showDialogModifyPwd.value = true;
  };

  const onModifyPwd = async () => {
    const updatePwd = {
      ancien_mot_de_passe: ancienPwd.value,
      nouveau_mot_de_passe: newPwd.value
    };
    if (newPwd.value !== confirmPwd.value) {
        message.value = "Les mots de passe ne correspondent pas."
        showWarn(message)
        return;
      }
    try {
      const response = await axios.put(`/api/user/password/${props.id}`, updatePwd, {
      headers: {
        Authorization: `Bearer ${localStorage.getItem('token')}`
      }
    });

    if (response.status === 200) {
      message.value = response.data.message
      showSuccess(message)
      showDialogModifyPwd.value = false;
    }
  } catch (err) {
    message.value = err.response.data.error
    showWarn(message)
  }
  };
  const showWarn = (message) => {
    toast.add({ severity: 'error', summary: "Message d'erreur", detail: message, life: 3000 });
  };
  const showSuccess = (message) => {
    toast.add({ severity: 'success', summary: "Succès", detail: message, life: 3000 });
  };

// Utiliser le routeur pour naviguer
const router = useRouter()
</script>

<template>
  <body :class="{ 'body-pd': isNavVisible }" id="body-pd">
    <header :class="{ 'body-pd': isNavVisible }" class="header" id="header">
      <div class="header_toggle" @click="toggleNavbar">
        <i :class="isNavVisible ? 'bx bx-x' : 'bx bx-menu'" id="header-toggle"></i>
      </div>
      <div class="flex" :style="{color:'white',}">
        <div class="text-uppercase fw-bold mr-2">{{ props.prenom }} {{ props.nom }}</div>
        <div> ( {{ props.role }} )</div>
      </div>
      <div class="header_img">
        <img id="nav-title" target="_blank" src="./../../assets/logo_white.png" width="200px"/>
      </div>
    </header>

    <div :class="['l-navbar', { show: isNavVisible }]" id="nav-bar">
      <nav class="nav">
        <div class="nav_logo">
        </div>
        <div>
          <div class="nav_list">
            <a @click="() => router.push('/app/users')" class="nav_link" v-if="role === 'RH' || role === 'administrateur'">
              <i class="bx bx-user nav_icon"></i>
              <span class="nav_name">Utilisateurs</span>
            </a>

            <a @click="() => router.push('/app/graph')" class="nav_link">
              <i class="bx bx-chart nav_icon"></i>
              <span class="nav_name">Mes trajets</span>
            </a>

            <a @click="() => router.push('/app/graphtest')" class="nav_link">
              <i class="bx bx-chart nav_icon"></i>
              <span class="nav_name">Mes trajets test</span>
            </a>

          </div>
        </div>
        <div class=" d-flex flex-column">
          <div @click="modifyPwd" class="mb-1 nav_link" v-if="isNavVisible === true">
            <span class="nav_name">Changer le mot de passe</span>
          </div>
          <div @click="logout" class="nav_link">
            <i class="bx bx-log-out nav_icon"></i>
            <span class="nav_name">Se déconnecter</span>
          </div>
        </div>
      </nav>
      <Toast />
      <Dialog v-model:visible="showDialogModifyPwd" header="Modifier le mot de passe" :style="{ width: '40%', backgroundColor: '#52422d', color: '#F7F6FB', borderColor:'#52422d' }" position="top" :modal="true" :closable="false">
      <div class="relative column wrap align-content-end" :style="{height:'12.5rem'}">
        <div class="w-7/8">
          <FloatLabel variant="on" class="mb-4">
            <Password inputClass="custominput w-full" style="width:100%;" required v-model="ancienPwd" id="ancienPwd" :feedback="false" toggleMask />
            <label for="ancienPwd" class="customlabel">Ancien mot de passe</label>
          </FloatLabel>
          <FloatLabel variant="on" class="mb-4">
            <Password inputClass="custominput w-full" style="width:100%;" required v-model="newPwd" id="newPwd" promptLabel="Choisir un nouveau mot de passe" weakLabel="Faible" mediumLabel="Moyen" strongLabel="Fort" toggleMask />
            <label for="newPwd" class="customlabel">Nouveau mot de passe</label>
          </FloatLabel>
          <FloatLabel variant="on">
            <Password inputClass="custominput w-full" style="width:100%;" required v-model="confirmPwd" id="confirmPwd" promptLabel="Confirmer le mot de passe" weakLabel="Faible" mediumLabel="Moyen" strongLabel="Fort" toggleMask />
            <label for="confirmPwd" class="customlabel">Confirmer le mot de passe</label>
          </FloatLabel>
        </div>
      </div>
      <template #footer>
        <Button label="Annuler" severity="secondary" @click="showDialogModifyPwd = false" />
        <Button label="Modifier" severity="warn" @click="onModifyPwd"  />
      </template>
    </Dialog>

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
  --white-color: #52422d;
  --black-color: black;
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
  width: 100px;
  height: 35px;
  display: flex;
  justify-content: center;
  border-radius: 50%;
  overflow: hidden;
}
.header_img img {
  width: 200px;
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
.nav_link:hover, .header_toggle:hover {
  color: var(--black-color);
  cursor: pointer;
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
  color: white;
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
    padding-left: calc(var(--nav-width));
  }
  .header {
    height: calc(var(--header-height) + 1rem);
    padding: 0 2rem 0 calc(var(--nav-width) + 2rem);
  }
  .header_img {
    width: 100px;
    height: 45px;
  }
  .header_img img {
    width: 100px;
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

