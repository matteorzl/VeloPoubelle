<script setup>
  import { ref, onBeforeMount } from 'vue';
  import Select from 'primevue/select';
  import axios from 'axios';
  import router from './../router/index'
  import { useRoute } from 'vue-router';
  axios.defaults.baseURL = 'http://localhost:3000';

  const url = useRoute().path.split("/").slice(-1)[0];
  console.log(url);
  const error = ref(null);
  const user = ref(undefined);

  const roles = ref([
    { name: 'Cycliste', value:'cycliste' },
    { name: 'RH', value:'RH' },
    { name: 'Admin', value:'administrateur' },
    { name: 'Gestionnaire', value:'gestionnaire_reseau' }
  ]);

  async function getUser(){
    try{
      await axios.get(`api/user/${url}`).then(res=>{
          user.value = res.data
          console.log(res.data)
        })
        console.log(user.value)
    }
    catch(error) {
      console.error('Error fetching user data:', error);
    };
  }

  const updateUser = async () => {
    error.value = null; 
        const updatedUser = {
          nom: user.value.nom,
          prenom: user.value.prenom,
          email: user.value.email,
          role: user.value.role.value,
        };

        try {
            const response = await axios.put(`/api/user/${url}`,updatedUser) // Send entire object

            if (response.status === 200) {
                router.push('../users');
            }
          } catch (err) {
            setTimeout(() => {
                error.value = err.response?.data?.error || 'Erreur lors de la connexion';
            }, 2000);
        }
    };

  onBeforeMount(() => {
    getUser()
  });

</script>

<template>
  <div class="container">
        <div class="row">
            <div class="col-md-8 col-md-offset-2">
                <div class="panel panel-default">
                  <div class="text-900 text-3xl font-bold mb-3">Modifier le profil</div>
                    <div class="panel-body"></div>
                      <form @submit.prevent="updateUser">
                        <div v-if="user" class="relative column wrap align-center">
                          <div class="w-10/12">
                            <FloatLabel class="mb-6">
                              <InputText class="w-full" id="prenom" required v-model="user.prenom" />
                              <label for="prenom">Prénom</label>
                            </FloatLabel>
                            <FloatLabel class="mb-6">
                              <InputText class="w-full" id="nom" required v-model="user.nom" />
                              <label for="nom">Nom</label>
                            </FloatLabel>
                            <FloatLabel class="mb-6">
                              <InputText class="w-full" id="mail" required v-model="user.email" />
                              <label for="mail">Adresse e-mail</label>
                            </FloatLabel>
                            <FloatLabel class="mb-6"  >
                              <Select v-model="user.role" inputId="role" :options="roles" optionLabel="name" placeholder="Selectionner un rôle" checkmark :highlightOnSelect="false" class="w-full md:w-56"></Select>
                              <label for="role">Role</label>
                            </FloatLabel>
                            <Button v-if="serverResponse !== 200 && serverResponse !== '401'" label="Enregistrer" type="submit" rounded class="w-full bg-[#2B2318]"></Button>
                          </div>
                        </div>
                        
                        <div v-else>
                          <p>Utilisateur non trouvé.</p>
                        </div>
                      </form>
                </div>
            </div>
        </div>
  </div>
  </template>
  
  <!-- <script>
  import Select from 'primevue/select';
  import axios from 'axios';
  import router from './../router/index'
  import { RouterLink } from 'vue-router';
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
  </script> -->