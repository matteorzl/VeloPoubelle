import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'
import PrimeVue from 'primevue/config';
import { definePreset } from '@primevue/themes';
import ToastService from 'primevue/toastservice';
import Aura from '@primevue/themes/aura';
import App from './App.vue'
import router from './router'
import 'leaflet/dist/leaflet.css';

const app = createApp(App)

const Noir = definePreset(Aura, {
    semantic: {
        primary: {
            50: '{zinc.50}',
            100: '{zinc.100}',
            200: '{zinc.200}',
            300: '{zinc.300}',
            400: '{zinc.400}',
            500: '{zinc.500}',
            600: '{zinc.600}',
            700: '{zinc.700}',
            800: '{zinc.800}',
            900: '{zinc.900}',
            950: '{zinc.950}'
        },
        colorScheme: {
            light: {
                primary: {
                    color: '#2B2318',
                    inverseColor: '#2B2318',
                    hoverColor: '#564730',
                    activeColor: '#2B2318'
                },
                highlight: {
                    background: '{zinc.950}',
                    focusBackground: '{zinc.700}',
                    color: '{zinc.950}',
                    focusColor: '{zinc.950}'
                }
            },
            dark: {
                primary: {
                    color: '{zinc.950}',
                    inverseColor: '{zinc.950}',
                    hoverColor: '{zinc.900}',
                    activeColor: '{zinc.800}'
                },
                highlight: {
                    background: '{zinc.950}',
                    focusBackground: '{zinc.700}',
                    color: '{zinc.950}',
                    focusColor: '{zinc.950}',
                }
            },
        }
    }
});

app.use(PrimeVue, {
    zIndex: {
        modal: 1100,        //dialog, drawer
        overlay: 1000,      //select, popover
        menu: 1000,       //overlay menus
        tooltip: 1100       //tooltip
    },
    // Default theme configuration
    theme: {
        preset: Noir,
        extend: {
            colors: {
              'mrfonce': '#2B2318',
            },
        },
        options: {
            prefix: 'p',
            darkModeSelector: '.my-app-dark',
            cssLayer: false
        }
        
    }
 });
app.use(ToastService);
app.use(createPinia())
app.use(router)

app.mount('#app')
