<template>
    <div>
        <Sidebar :nom="nom" :prenom="prenom"/>
        <div style="background-color: black !important; width: 900px; height: 1244px; margin-left: 25%; margin-top: 1%">
            {{ user }}
        </div>
    </div>
</template>

<script>
import axios from 'axios';
axios.defaults.baseURL = 'http://localhost:3000';

export default {
    data(){
        return{
            nom: " ",
            prenom: " "
        }
    },
    async created() {
        await axios
        .get('/api/app')
        .then(response => (this.nom = response.data.nom, this.prenom = response.data.prenom))
  },
}

</script>