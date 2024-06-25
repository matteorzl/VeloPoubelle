<script setup>
import { ref } from 'vue';
import axios from 'axios';
import router from './../router/index'
axios.defaults.baseURL = 'http://localhost:3000';

const lastName = ref('');
const firstName = ref('')
const mail = ref('');
const password = ref('');
const role = ref('cycliste');
const error = ref(null);

const signup = async () => {
  error.value = null;
  try {
    console.log(lastName.value,firstName.value,mail.value,password.value,role.value)
    const response = await axios.post('/api/signup', {
      nom: lastName.value,
      prenom: firstName.value, 
      email: mail.value,
      mot_de_passe: password.value,
      role: role.value
    });

    if (response.status === 201) {
      setTimeout(() => {
        router.push('/login');
      }, 2000); 
    }
  } catch (err) {
    error.value = err.response?.data?.error || 'Erreur lors de la création du compte';
  }
};
</script>

<template>
  <div class="mx-auto surface-card p-4 shadow-2 border-round" style="width:600px">
    <div class="text-center mb-5">
      <img src="./../assets/logo.png" class="mx-auto" width="400px" />
      <div class="text-900 text-3xl font-bold mb-3">Créer un Compte</div>
      <span class="text-600 font-medium line-height-3">Déjà un compte ?</span>
      <RouterLink class="font-medium underline ml-2 cursor-pointer" to="/login">Connectez-vous</RouterLink>
    </div>

    <form @submit.prevent="signup">
      <div class="relative column wrap align-center">
        <div class="w-10/12">
          <FloatLabel class="mb-6">
            <InputText class="w-full" id="lastName" v-model="lastName"/>
            <label for="lastName">Nom</label>
          </FloatLabel>
          <FloatLabel class="mb-6">
            <InputText class="w-full" id="firstName" v-model="firstName"/>
            <label for="firstName">Prénom</label>
          </FloatLabel>
          <FloatLabel class="mb-6">
            <InputText class="w-full" id="mail" v-model="mail"/>
            <label for="mail">Adresse mail</label>
          </FloatLabel>
          <FloatLabel class="mb-6">
            <Password inputClass="w-full" style="width:100%;" v-model="password" id="password" promptLabel="Choisir un mot de passe" weakLabel="Faible" mediumLabel="Moyen" strongLabel="Fort" toggleMask />
            <label for="password">Mot de passe</label>
          </FloatLabel>

          <Button label="Créer le compte" rounded class="w-full" type="submit"></Button>

          <div v-if="error" class="error">{{ error }}</div>
        </div>
      </div>
    </form>
  </div>
</template>

<style>
.error {
  color: red;
}
</style>