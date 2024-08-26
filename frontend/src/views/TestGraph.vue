<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { Line} from 'vue-chartjs'
import {
    Chart as ChartJS,
    Title,
    Tooltip,
    Legend,
    LineElement,
    PointElement,
    LinearScale,
    CategoryScale
} from 'chart.js'

ChartJS.register(Title, Tooltip, Legend, LineElement, PointElement, LinearScale, CategoryScale)

const chartData = ref({
    labels: [],
    datasets: []
});
const chartOptions = {
    responsive: true,
    maintainAspectRatio: false
};

let intervalId = null;
const vitesse = 20; // en km/h
const distanceEntreArrets = 500; // en mètres
const positions = [0, 500, 1000, 1500, 2000]; // distance cumulée pour chaque arrêt en mètres
let tempsRestantRue = 0;
let tempsRestantTournee = 0;
let currentIndex = 0;
let startTime = 0;

const tempsParArret = computed(() => {
    return (distanceEntreArrets / (vitesse * 1000 / 3600)).toFixed(2); // en secondes
});

const tempsTotalTournee = computed(() => {
    return (positions.length - 1) * tempsParArret.value;
});

function updateChart() {
    if (currentIndex < positions.length - 1) {
        tempsRestantRue = tempsParArret.value - ((Date.now() - startTime) / 1000).toFixed(2);
        tempsRestantTournee = tempsTotalTournee.value - ((currentIndex * tempsParArret.value) + (tempsParArret.value - tempsRestantRue)).toFixed(2);

        if (tempsRestantRue <= 0) {
            currentIndex++;
            startTime = Date.now();
        }

        chartData.value = {
            labels: positions.map(pos => `Arret ${positions.indexOf(pos) + 1}`),
            datasets: [
                {
                    label: 'Progression',
                    data: positions.map((pos, index) => (index <= currentIndex) ? pos : null),
                    borderColor: 'green',
                    backgroundColor: 'transparent',
                    borderWidth: 2,
                    pointRadius: 5,
                    pointBackgroundColor: positions.map((pos, index) => (index === currentIndex) ? 'green' : 'white')
                }
            ]
        };
    } else {
        clearInterval(intervalId);
    }
}

function startProgress() {
    startTime = Date.now();
    intervalId = setInterval(updateChart, 1000);
}

onMounted(() => {
    chartData.value = {
        labels: positions.map(pos => `Arret ${positions.indexOf(pos) + 1}`),
        datasets: [
            {
                label: 'Progression',
                data: [0],
                borderColor: 'green',
                backgroundColor: 'transparent',
                borderWidth: 2,
                pointRadius: 5,
                pointBackgroundColor: ['green', 'white', 'white', 'white', 'white']
            }
        ]
    };
    startProgress();
});

onBeforeUnmount(() => {
    clearInterval(intervalId);
});
</script>

<template>
    <div>
        <Line :chart-data="chartData" :options="chartOptions"></Line>
        <div>
            <p>Temps restant pour cette rue : {{ tempsRestantRue }} s</p>
            <p>Temps restant pour toute la tournée : {{ tempsRestantTournee }} s</p>
        </div>
    </div>
</template>

<style scoped>
canvas {
    width: 100%;
    height: 300px;
}
</style>
