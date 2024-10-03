<script setup>
    import { ref } from 'vue';
    import axios from 'axios';
    import router from '../router/index'
    axios.defaults.baseURL = 'http://localhost:3000';

    const mail = ref('');
    const password = ref('');
    const error = ref(null);
    let serverResponse = ref('')

    const login = async () => {
        error.value = null; 

        try {
            const response = await axios.post('/api/login', {
                email: mail.value,
                mot_de_passe: password.value 
            });

            localStorage.setItem('token', response.data.token);

            serverResponse.value = response.status

            if (response.status === 200) {
                setTimeout(() => {
                    router.push('/app');
                }, 2000); 
            }
        } catch (err) {
            serverResponse.value = '401'
            setTimeout(() => {
                error.value = err.response?.data?.error || 'Erreur lors de la connexion';
                serverResponse.value = ''
            }, 2000);
        }
    };
</script>

<template>
    <div class="mx-auto surface-card p-4 shadow-2 border-round" style="width:600px">
        <div class="text-center mb-5">
            <img src="./../assets/logo.png" class="mx-auto" width="400px"/>
            <div class="text-900 text-3xl font-bold mb-3">Connexion</div>
            <span class="text-600 font-medium line-height-3">Pas de compte ?</span>
            <RouterLink class="font-medium underline ml-2 cursor-pointer" to="/register">Créer compte</RouterLink>
        </div>
        <form @submit.prevent="login">
            <div class="relative column wrap align-center">
                <div class="w-10/12">
                    <FloatLabel class="mb-6">
                        <InputText class="w-full" id="mail" required v-model="mail" />
                        <label for="mail">Adresse e-mail</label>
                    </FloatLabel>
                    <FloatLabel class="mb-6" >
                        <InputText type="password" class="w-full" id="password" required v-model="password" />
                        <label for="password">Mot de passe</label>
                    </FloatLabel>
                    <div class="flex align-items-center justify-content-between mb-6">
                        <div class="flex align-items-center">
                            <Checkbox id="rememberme1" v-model="rememberMe" class="mr-2"></Checkbox>
                            <label for="rememberme1">Se souvenir de moi</label>
                        </div>
                        <a class="font-medium underline ml-2 text-right cursor-pointer">Mot de passe oublié ?</a>
                    </div>
                    <Button v-if="serverResponse !== 200 && serverResponse !== '401'" label="Se connecter" type="submit" rounded class="w-full bg-[#2B2318]"></Button>
                    <ProgressSpinner v-if="serverResponse === 200 || serverResponse.length > 2 && !error" style="width: 50px; height: 50px;top:45%;left:45%" strokeWidth="8" fill="transparent" animationDuration=".5s" aria-label="Custom ProgressSpinner"/>

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