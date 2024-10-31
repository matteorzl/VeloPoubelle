<template>
    <form @submit.prevent="updateUser">
      <div v-if="user">
        <h2>Modifier le profil</h2>
        <label for="nom">Nom :</label>
        <input type="text" id="nom" v-model="user.nom">
  
        <label for="prenom">Prénom :</label>
        <input type="text" id="prenom" v-model="user.prenom">
  
        <label for="email">Email :</label>
        <input type="email" id="email" v-model="user.email">

        <label for="role">Rôle :</label>
        <select id="role" v-model="user.role">
            <option value="cycliste">Cycliste</option>
            <option value="RH">RH</option>
            <option value="administrateur">Admin</option>
            <option value="gestionnaire_reseau">Gestionnaire</option>
        </select>
  
        <button type="submit">Enregistrer</button>
      </div>
      <div v-else>
        <p>Utilisateur non trouvé.</p>
      </div>
    </form>
  </template>
  
  <script>
  import axios from 'axios';
  import router from './../router/index'
  axios.defaults.baseURL = 'http://localhost:3000';

export default{
    name:'User',
    data(){
        return{
            user:null
        }
    },
    mounted(){
        this.getUser();
    },
    methods: {
        getUser(){
            axios.get('api/user/' + this.$route.params.id).then(res=>{
                this.user = res.data
                console.log(this.user)
            });
        },
        updateUser() {
        const updatedUser = {
          nom: this.user.nom,
          prenom: this.user.prenom,
          email: this.user.email,
          role: this.user.role,
        };

      axios.put(`/api/user/${this.$route.params.id}`, updatedUser) // Send entire object
        .then((res) => {
          console.log('User updated successfully:', res.data); // Consider using success message
          router.push('../users');// Optionally handle successful update (e.g., redirect, display success message)
        })
        .catch((error) => {
          console.error('Error updating user:', error.response?.data); // Access error details from response
          // Handle errors appropriately (e.g., display error message to user)
        });
    },
  },
};
  </script>