<template>
    <div class="mx-auto surface-card p-4 shadow-2 border-round" style="width:600px">
        <div class="text-center mb-5">
            <img src="./../assets/LogoBB.png" class="mx-auto" width="400px"/>
            <div class="text-900 text-3xl font-bold mb-3">Connexion</div>
            <span class="text-600 font-medium line-height-3">Pas de compte ?</span>
            <RouterLink class="font-medium underline ml-2 cursor-pointer" to="/register">Créer compte</RouterLink>
        </div>

        <div class="relative column wrap align-center">
            <div class="w-10/12">
                <FloatLabel class="mb-6">
                    <InputText class="w-full" id="username" v-model="username" />
                    <label for="username">Nom d'utilisateur</label>
                </FloatLabel>
                <FloatLabel class="mb-6">
                    <InputText class="w-full" id="password" v-model="password" />
                    <label for="password">Mot de passe</label>
                </FloatLabel>
                <div class="flex align-items-center justify-content-between mb-6">
                    <div class="flex align-items-center">
                        <Checkbox id="rememberme1" v-model="rememberMe" class="mr-2"></Checkbox>
                        <label for="rememberme1">Se souvenir de moi</label>
                    </div>
                    <a class="font-medium underline ml-2 text-right cursor-pointer">Mot de passe oublié ?</a>
                </div>
                <Button label="Se connecter" rounded class="w-full bg-[#2B2318]"></Button>
            </div>
        </div>
    </div>
</template>

<script setup>
    import { ref } from 'vue';
    import { RouterLink } from 'vue-router';

    let username = ref(null)
    let password = ref(null)
    let rememberMe = ref(null)
</script>