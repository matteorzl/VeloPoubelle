import { createRouter, createWebHistory } from 'vue-router';
import Login from '@/views/Login.vue';
import Register from '@/views/Register.vue';
import Application from '@/views/Application.vue';
import Map from '@/views/Map.vue';
import Users from '@/views/Users.vue';
import MapCyclist from '@/views/MapCyclist.vue';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: Login
    },
    {
      path: '/login',
      name: 'login',
      component: Login
    },
    {
      path: '/register',
      name: 'register',
      component: Register
    },
    {
      path: '/app',
      component: Application,
      children: [
        {
          path: '', // `/app` affichera par défaut `Users`
          name: 'users',
          component: Users
        },
        {
          path: 'map', // `/app/map`
          name: 'map',
          component: Map
        },
        {
          path: 'users', // `/app/users`
          name: 'Users',
          component: Users
        },
        {
          path: 'mapcyclist', // `/app` affichera par défaut `Users`
          name: 'mapcyclist',
          component: MapCyclist
        },
      ]
    }
  ]
});

export default router;
