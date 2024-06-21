<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'

</script>

<template>
  <header>
    <div class="wrapper">
      <nav>
        <RouterLink to="/login">Login</RouterLink>
        <RouterLink to="/home">Home</RouterLink>
      </nav>
    </div>
  </header>

  <RouterView />
</template>

<style>
  body {
    background-color: #e4dfd0;
  }
</style>
