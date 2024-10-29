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
            <option value="rh">RH</option>
            <option value="admin">Admin</option>
            <option value="gestionnaire">Gestionnaire</option>
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
            axios.put('api/user/'+this.$route.params.id, this.user)
            .then(response => {
            // Gérer la réponse après la mise à jour
            console.log('Utilisateur mis à jour avec succès');
            })
            .catch(error => {
            console.error(error);
            });
    }
    }
}
  </script>