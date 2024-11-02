<template>
    <div class="container">
        <div class="row">
            <div class="col-md-8 col-md-offset-2">
                <div class="panel panel-default">
                    <div class="panel-heading">Listes des utilisateurs</div>
                    <div class="panel-body">
                        <table class="table">
                            <thead>
                              <tr>
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Email</th>
                                <th>Role</th>
                              </tr>
                            </thead>
                            <tbody>
                              <tr v-for="(user,index) in this.users" :key="index">
                                <td>{{user.nom}}</td>
                                <td>{{user.prenom}}</td>
                                <td>{{user.email}}</td>
                                <td>{{user.role}}</td>
                                <td><router-link :to="{ path: '/user/'+ user.id_utilisateur}" class="btn btn-success float-end">Modifier</router-link></td>
                              </tr>
                          </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
import { ref, onMounted} from 'vue'
import axios from 'axios';
axios.defaults.baseURL = 'http://localhost:3000';

export default{
    name:'Users',
    data(){
        return{
            users: []
        }
    },
    mounted(){
        this.getUsers();
    },
    methods: {
        getUsers(){
            axios.get('/api/users').then(res=>{
                this.users = res.data
                console.log(this.users)
            });
        }
    }
}
</script>