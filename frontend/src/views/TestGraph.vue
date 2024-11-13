<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import VueApexCharts from 'vue3-apexcharts'

// Configuration du graphique
const chartOptions = ref({
    chart: {
        type: 'line',
        height: 300,
        animations: {
            enabled: true,
            easing: 'linear',
            dynamicAnimation: {
                speed: 1000
            }
        }
    },
    stroke: {
        curve: 'smooth',
        width: 2
    },
    fill: {
        type: 'gradient',
        gradient: {
            shade: 'light',
            type: 'horizontal',
            shadeIntensity: 0.5,
            gradientToColors: ['#00E396'],
            opacityFrom: 0.5,
            opacityTo: 0.1
        }
    },
    xaxis: {
        categories: ["Arret 1", "Arret 2", "Arret 3", "Arret 4", "Arret 5"]
    },
    yaxis: {
        min: 0,
        max: 100,
        title: {
            text: 'Progression'
        }
    },
    markers: {
        size: 5,
        colors: ['#FFFFFF'],
        strokeColors: '#00E396',
        strokeWidth: 2,
    },
    series: [{
        name: 'Progression',
        data: [0, 0, 0, 0, 0]
    }]
});

// Variables pour le calcul des distances
const vitesse = 20; // en km/h
const distanceEntreArrets = 500; // en mètres
const positions = [0, 500, 1000, 1500, 2000]; // distance cumulée pour chaque arrêt en mètres
const distanceRestanteRue = ref(distanceEntreArrets); // Distance restante jusqu'au prochain arrêt
const distanceRestanteTournee = ref(positions[positions.length - 1]); // Distance restante pour la tournée
let currentIndex = 0; // Index de l'arrêt actuel
let startTime = 0; // Heure de départ pour calculer la distance parcourue
let intervalId = null;

// Fonction de mise à jour de la progression et du graphique
function updateProgress() {
    const elapsedTime = (Date.now() - startTime) / 1000; // Temps écoulé en secondes
    const distanceParcourue = (vitesse * 1000 / 3600) * elapsedTime; // Distance parcourue en mètres

    // Calcul des distances restantes en arrondissant les valeurs
    distanceRestanteRue.value = Math.max(0, Math.round(distanceEntreArrets - distanceParcourue));
    distanceRestanteTournee.value = Math.max(0, Math.round(distanceRestanteTournee.value - distanceParcourue));

    // Mise à jour du graphique avec un remplissage entre les arrêts
    chartOptions.value.series[0].data = positions.map((pos, index) => {
        if (index < currentIndex) {
            return 100; // Remplissage complet entre les arrêts déjà atteints
        }
        if (index === currentIndex) {
            // Position du point de progression entre les arrêts
            const progress = (distanceParcourue / distanceEntreArrets) * 100; // Pourcentage de progression
            return progress;
        }
        return 0; // Pas de remplissage pour les arrêts futurs
    });

    // Vérifie si on a atteint l'arrêt actuel
    if (distanceRestanteRue.value <= 0) {
        currentIndex++;
        startTime = Date.now(); // Réinitialise le temps de départ pour le prochain arrêt

        // Arrête l'intervalle si on a atteint le dernier arrêt
        if (currentIndex >= positions.length - 1) {
            clearInterval(intervalId);
            distanceRestanteTournee.value = 0; // Assure que la distance de la tournée affiche "0 m"
        }
    }
}

// Démarre la progression de la tournée
function startProgress() {
    startTime = Date.now();
    intervalId = setInterval(updateProgress, 1000);
}

onMounted(() => {
    startProgress();
});

onBeforeUnmount(() => {
    clearInterval(intervalId);
});
</script>

<template>
    <div>
        <!-- Utilise ApexCharts pour afficher la progression avec remplissage entre les arrêts -->
        <VueApexCharts type="line" :options="chartOptions" :series="chartOptions.series" />
        
        <!-- Informations de distance restante -->
        <div>
            <p>Distance restante pour cette rue : {{ distanceRestanteRue }} m</p>
            <p>Distance restante pour toute la tournée : {{ distanceRestanteTournee }} m</p>
        </div>
    </div>
</template>

<style scoped>
/* Ajustement du style du graphique */
</style>
