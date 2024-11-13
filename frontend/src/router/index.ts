import { createRouter, createWebHistory } from 'vue-router';
import Login from '@/views/Login.vue';
import Register from '@/views/Register.vue';
import Test from '@/views/Test.vue';
import Application from '@/views/Application.vue';
import Leaflet from '@/views/Leaflet.vue';
import TestGraph from '@/views/TestGraph.vue';
import Users from '@/views/Users.vue';

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
          path: 'graph', // `/app/graph`
          name: 'graph',
          component: TestGraph
        },
        {
          path: 'graphtest', // `/app/graph`
          name: 'graphtest',
          component: Leaflet
        },
        {
          path: 'users', // `/app/users`
          name: 'Users',
          component: Users
        }
      ]
    }
  ]
});

export default router;
