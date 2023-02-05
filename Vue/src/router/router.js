import Vue from 'vue';
import VueRouter from 'vue-router';
import Home from '../views/Home.vue';
import Info from '../views/Info.vue';
import Register from '../views/Register.vue';
import Doctor from '../views/Doctor.vue';
import Patient from '../views/Patient.vue';

Vue.use(VueRouter);

const router = new VueRouter({
  mode: 'hash',
  routes: [
    { path: '/Info', name: 'info', component: Info },
    { path: '/Home', name: 'home', component: Home },
    { path: '/Register', name: 'register', component: Register },
    { path: '/Doctor', name: 'doctor', component: Doctor },
    { path: '/Patient', name: 'patient', component: Patient },
  ],
});

export default router;