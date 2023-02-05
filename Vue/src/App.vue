<template>
  <router-view></router-view>
</template>

<script>
  import Home from '../src/views/Home.vue';
  export default {
    name: 'App',
    data : () => ({
    }),
    created() {
      this.$router.push( { name: 'home' } );
    },
    methods: {
    }
  }
</script>
