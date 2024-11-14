<script setup>
  import { ref, onMounted} from 'vue';
  import axios from 'axios';
  axios.defaults.baseURL = 'http://localhost:3000';
  import Dialog from 'primevue/dialog';
  import Button from 'primevue/button';
  import FloatLabel from 'primevue/floatlabel';

  const users = ref([]);
  const actualUser = ref(undefined)
  const user = ref('');
  const lastName = ref('');
  const firstName = ref('')
  const mail = ref('');
  const password = ref('');
  const userrole = ref(undefined);

  const deleteUserId = ref(null);
  const modifyUserId = ref(null);

  const showDialogDelete = ref(false);
  const showDialogModify = ref(false);
  const showDialogCreate = ref(false);

  const error = ref(null);
  const position = ref('center');
  const visible = ref(false);

  const Adminroles = ref([
    { name: 'Cycliste', value:'cycliste' },
    { name: 'RH', value:'RH' },
    { name: 'Admin', value:'administrateur' },
    { name: 'Gestionnaire', value:'gestionnaire_reseau' }
  ]);

  const Rhroles = ref([
    { name: 'Cycliste', value:'cycliste' },
    { name: 'RH', value:'RH' },
    { name: 'Gestionnaire', value:'gestionnaire_reseau' }
  ]);

  async function getActualUser(){
  if(localStorage.getItem("token")) {
    try{
      const resp = await axios.get('/api/app', {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
      })
      actualUser.value = resp.data.message
    }
    catch(error) {
      console.error('Error fetching user data:', error)
    }
  }else{
    router.push("/login")
    }
  }

  async function getUsers(){
    try{
      await axios.get(`api/users`).then(res=>{
          users.value=res.data
        })
    }
    catch(error) {
      console.error('Error fetching users data:', error);
    };
  }

  const modifyUser = async (id,pos) => {
    try {
        const res = await axios.get(`api/user/${id}`); 
        user.value = res.data;
        position.value = pos;
        visible.value = true;
        modifyUserId.value = id;
        showDialogModify.value = true;
    } catch (err) {
        console.error('Error fetching user data:', err);
    }
  };

  const addUser = () => {
    position.value = 'top';
    visible.value = true;
    showDialogCreate.value = true;
  };

  const confirmDelete = (id,pos) => {
    position.value = pos;
    visible.value = true;
    deleteUserId.value = id;
    showDialogDelete.value = true;
  };

  const onDelete = async () => {
   try {
    const response = await axios.delete(`/api/user/${deleteUserId.value}`);
    if (response.status === 200) {
    users.value = users.value.filter(user => user.id_utilisateur !== deleteUserId.value);
    showDialogDelete.value = false;
    }
   } catch (err) {
    error.value = err.response?.data?.error || 'Erreur lors de la suppression';
   }
  };

  const onModify = async () => {
    const updatedUser = {
      nom: user.value.nom,
      prenom: user.value.prenom,
      email: user.value.email,
      role: user.value.role.value,
    };

    try {
        const response = await axios.put(`/api/user/${modifyUserId.value}`,updatedUser) // Send entire object

        if (response.status === 200) {
            getUsers()
            showDialogModify.value = false;
        }
      } catch (err) {
        setTimeout(() => {
            error.value = err.response?.data?.error || 'Erreur lors de la connexion';
        }, 2000);
    }
  };

  const onCreate = async () => {
    try {
      const response = await axios.post('/api/register', {
        nom: lastName.value,
        prenom: firstName.value, 
        email: mail.value,
        mot_de_passe: password.value,
        role: userrole.value.value
      });

    if (response.status === 201) {
      getUsers()
      showDialogCreate.value = false;
    }
  } catch (err) {
    error.value = err.response?.data?.error || 'Erreur lors de la création du compte';
  }
  };

  onMounted(() => {
    getActualUser();
    getUsers();
});
</script>
<template>
  <div class="container">
    <div class="row">
      <div class="col-md-8 col-md-offset-2">
        <div class="panel panel-default">
          <div class="panel-body">
            <table class="table">
                <thead>
                  <tr>
                    <th>Prénom</th>
                    <th>Nom</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Modifier</th>
                    <th>Supprimer</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(userlist, index) in users" :key="index">
                    <td>{{userlist.prenom}}</td>
                    <td>{{userlist.nom}}</td>
                    <td>{{userlist.email}}</td>
                    <td>{{userlist.role}}</td>
                    <td><Button label="Modifier" severity="warn" @click="modifyUser(userlist.id_utilisateur ,'top')" class="btn btn-outline-warning"/></td>
                    <td><Button label="Supprimer" severity="danger" @click="confirmDelete(userlist.id_utilisateur ,'top')" /></td>
                  </tr>
                </tbody>
            </table>
            <Button label="+ Ajouter un utilisateur" severity="success" @click="addUser()" />
          </div>
        </div>
      </div>
    </div>
    <Dialog v-model:visible="showDialogDelete" header="Confirmer la suppression" :position="position" :modal="true" :closable="false" :style="{ width: '400px', backgroundColor: '#52422d', color: '#F7F6FB', borderColor:'#52422d' }">
      <p>Êtes-vous sûr de vouloir supprimer cet utilisateur ?</p>
      <template #footer>
          <Button label="Annuler" severity="secondary" @click="showDialogDelete = false" />
          <Button label="Supprimer" severity="danger" @click="onDelete" class="p-button-danger" />
      </template>
    </Dialog>

    <Dialog v-model:visible="showDialogModify" header="Modifier l'utilisateur" :style="{ width: '40%', backgroundColor: '#52422d', color: '#F7F6FB', borderColor:'#52422d' }" :position="position" :modal="true" :closable="false">
      <div class="relative column wrap align-content-end" :style="{height:'18.5rem'}">
        <div class="w-7/8">
          <FloatLabel class="mb-4">
            <InputText class="custominput w-full" id="prenom" required v-model="user.prenom"/>
            <label for="prenom" class="customlabel">Prénom</label>
          </FloatLabel>
          <FloatLabel class="mb-4">
            <InputText class="custominput w-full" id="nom" required v-model="user.nom"/>
            <label for="nom" class="customlabel">Nom</label>
          </FloatLabel>
          <FloatLabel class="mb-4">
            <InputText class="custominput w-full" id="mail" required v-model="user.email"/>
            <label for="mail" class="customlabel">Adresse e-mail</label>
          </FloatLabel>
          <FloatLabel class="mb-4" v-if="actualUser.role === 'administrateur'">
            <Select v-model="user.role" inputId="role" :options="Adminroles" optionLabel="name" :placeholder="user.role" checkmark :highlightOnSelect="false" class="custominput w-full md:w-56" appendTo="body"></Select>
            <label for="role" class="customlabel">Role</label>
          </FloatLabel>
          <FloatLabel class="mb-4" v-else>
            <Select v-model="user.role" inputId="role" :options="Rhroles" optionLabel="name" :placeholder="user.role" checkmark :highlightOnSelect="false" class="custominput w-full md:w-56" appendTo="body"></Select>
            <label for="role" class="customlabel">Role</label>
          </FloatLabel>
        </div>
      </div>
      <template #footer>
        <Button label="Annuler" severity="secondary" @click="showDialogModify = false" />
        <Button label="Modifier" severity="warn" @click="onModify"  />
      </template>
    </Dialog>

    <Dialog v-model:visible="showDialogCreate" header="Créer l'utilisateur" :style="{ width: '40%', backgroundColor: '#52422d', color: '#F7F6FB', borderColor:'#52422d' }" :position="position" :modal="true" :closable="false">
      <div class="relative column wrap align-content-end mt-8" :style="{height:'21.5rem'}">
        <div class="w-10/12 ">
          <FloatLabel variant="on" class="mb-4">
            <InputText class="custominput w-full" id="firstName" required v-model="firstName"/>
            <label for="firstName" class="customlabel">Prénom</label>
          </FloatLabel>
          <FloatLabel variant="on" class="mb-4">
            <InputText class="custominput w-full" id="lastName" required v-model="lastName"/>
            <label for="lastName" class="customlabel">Nom</label>
          </FloatLabel>
          <FloatLabel variant="on" class="mb-4">
            <InputText class="custominput w-full" id="mail" required v-model="mail"/>
            <label for="mail" class="customlabel">Adresse mail</label>
          </FloatLabel>
          <FloatLabel variant="on" class="mb-4" v-if="actualUser.role === 'administrateur'">
              <Select v-model="userrole" inputId="roleCreate" :options="Adminroles" optionLabel="name" placeholder="Selectionner un role" checkmark :highlightOnSelect="false" class="custominput w-full md:w-56" appendTo="body"></Select>
              <label for="roleCreate" class="customlabel">Role</label>
          </FloatLabel>
          <FloatLabel class="mb-4" v-else>
            <Select v-model="userrole" inputId="role" :options="Rhroles" optionLabel="name" placeholder="Selectionner un role" checkmark :highlightOnSelect="false" class="custominput w-full md:w-56" appendTo="body"></Select>
            <label for="role" class="customlabel">Role</label>
          </FloatLabel>
          <FloatLabel variant="on" class="mb-4">
            <Password inputClass="custominput w-full" style="width:100%;" required v-model="password" id="password" promptLabel="Choisir un mot de passe" weakLabel="Faible" mediumLabel="Moyen" strongLabel="Fort" toggleMask />
            <label for="password" class="customlabel">Mot de passe</label>
          </FloatLabel>
        </div>
      </div>
      <template #footer>
        <Button label="Annuler" severity="secondary" @click="showDialogCreate = false" />
        <Button label="Créer" severity="success" @click="onCreate"  />
      </template>
    </Dialog>
  </div>
</template>
<style>
  .customlabel{
    color: white !important;
  }
  .custominput {
    background-color: #826b48 !important;
    border:none !important;
    color:white !important;
  }
  .p-placeholder,.p-select-label {
    color:white !important;
  }
</style>