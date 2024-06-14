<script setup>
import { ref } from 'vue';

let username = ref(null)
let password = ref(null)
let rememberMe = ref(null)

</script>

<template>
    <div class="surface-card p-4 shadow-2 border-round">
        <div class="text-center mb-5">
            <div class="text-900 text-3xl font-medium mb-3">Connexion</div>
            <span class="text-600 font-medium line-height-3">Pas de compte ?</span>
            <a class="font-medium underline ml-2 cursor-pointer">Créer compte</a>
        </div>

        <div>
            <FloatLabel class="mb-6">
                <InputText class="w-10/12" id="username" v-model="username" />
                <label for="username">Nom d'utilisateur</label>
            </FloatLabel>
            <FloatLabel class="mb-6">
                <InputText class="w-10/12" id="password" v-model="password" />
                <label for="password">Mot de passe</label>
            </FloatLabel>
            <div class="flex align-items-center justify-content-between mb-6">
                <div class="flex align-items-center">
                    <Checkbox id="rememberme1" v-model="rememberMe" class="mr-2"></Checkbox>
                    <label for="rememberme1">Se souvenir de moi</label>
                </div>
                <a class="font-medium underline ml-2 text-right cursor-pointer">Mot de passe oublié ?</a>
            </div>

            <Button label="Se connecter" rounded class="w-10/12 bg-black"></Button>
        </div>
    </div>
</template>