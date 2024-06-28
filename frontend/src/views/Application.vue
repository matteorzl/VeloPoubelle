<template>
    <div>
      <Sidebar :nom="user.nom" :prenom="user.prenom" />
      <div  style="background-color: black !important; width: 900px; height: 1244px; margin-left: 25%; margin-top: 1%">
   
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        user: null 
      };
    },
    mounted() {
      axios.get('/api/app', {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` } // Include the JWT token
      })
      .then(res => {
        this.user = res.data.message;
      })
      .catch(error => {
        console.error('Error fetching user data:', error);
        // Handle the error, e.g., redirect to login if the token is invalid
      });
    }
  };
  </script>