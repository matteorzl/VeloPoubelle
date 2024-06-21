<template>
    <div class="mx-auto surface-card p-4 shadow-2 border-round" style="width:600px">
      <div class="text-center mb-5">
        <img src="./../assets/LogoBB.png" class="mx-auto" width="400px" />
        <div class="text-900 text-3xl font-bold mb-3">Créer un Compte</div>
        <span class="text-600 font-medium line-height-3">Déjà un compte ?</span>
        <RouterLink class="font-medium underline ml-2 cursor-pointer" to="/login">Connectez-vous</RouterLink>
      </div>
  
      <div class="relative column wrap align-center">
        <div class="w-10/12">
          <FloatLabel class="mb-6">
            <InputText class="w-full" id="nom" v-model="nom" />
            <label for="nom">Nom</label>
          </FloatLabel>
          <FloatLabel class="mb-6">
            <InputText class="w-full" id="prenom" v-model="prenom" />
            <label for="prenom">Prénom</label>
          </FloatLabel>
          <FloatLabel class="mb-6">
            <InputText v-model="mail" class="w-full" id="mail" />
            <label for="mail">Adresse mail</label>
          </FloatLabel>
          <FloatLabel class="mb-6">
            <Password inputClass="w-full" style="width:100%;" v-model="password" id="password" promptLabel="Choisir un mot de passe" weakLabel="Faible" mediumLabel="Moyen" strongLabel="Fort" toggleMask />
            <label for="password">Mot de passe</label>
          </FloatLabel>
  
          <Button label="Créer le compte" rounded class="w-full" @click="registerUser"></Button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  import { RouterLink } from 'vue-router';
  import axios from 'axios';
  
  let nom = ref(null);
  let prenom = ref(null);
  let mail = ref(null);
  let password = ref(null);
  
  const registerUser = async () => {
    try {
        const response = await axios.post('http://agweco.fr/veloPoubelle/utilisateurs', {
        nom: nom.value,
        prenom: prenom.value,
        email: mail.value,
        mot_de_passe: password.value,
        role: 'cycliste' // Vous pouvez adapter ce rôle selon votre besoin
        });
        console.log('Utilisateur créé:', response.data);
        // Redirigez l'utilisateur vers la page de connexion ou affichez un message de succès
    } catch (error) {
        console.error('Erreur lors de la création de l\'utilisateur:', error);
        // Gérez l'erreur, par exemple, afficher un message d'erreur à l'utilisateur
    }
};
  </script>
  