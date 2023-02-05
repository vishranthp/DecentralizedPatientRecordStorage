<template>
    <b-container fluid style="background-color:teal; height:100vh;">
      <b-row>
        <b-col>
          <div class="sticky-top d-flex justify-content-center mt-3">
            <b-img :src="require('../assets/HomeBanner.jpg')" style="width:70vw;max-height:60vh;"></b-img>
          </div>
        </b-col>
      </b-row>
      <b-row>
        <b-col class="mt-3">
          <div class="d-flex justify-content-center text-light" >
            <h3 style="width:70vw;">Take control of your own data. Store your Electronic Health Records in a Safe and Secured Blockchain network.</h3>
          </div>
        </b-col>
      </b-row>
      <b-row align-h="center" class="mt-4">
        <b-col class="d-flex justify-content-center" cols="2">
          <b-button variant="info" @click="showInfo">Learn More</b-button>
        </b-col>
        <b-col cols="2">
            <b-button variant="success" class="ml-3" @click="login">Log in</b-button>
        </b-col>
      </b-row>
      <b-row>
        <b-col offset-md="6" cols="4">
            <a style="color:white;cursor:pointer;font-size:13px;margin-left:14px;" @click="register">Sign Up</a>
        </b-col>
      </b-row>
      <div class="fixed-bottom d-flex justify-content-center"><a href="https://www.freepik.com/free-vector/digital-healthcare-technology-flat-infographic_6345813.htm#page=2&query=electronic%20medical%20record&position=35&from_view=keyword">Image by macrovector</a> on Freepik</div>
    </b-container>
  </template>
  
  <script>
    import Web3 from 'web3';

    export default {
      data : () => ({
      }),

      methods: {
        showInfo() {
          this.$router.push( { name: 'info' } );
        },
        register() {
            this.$router.push({name:'register'});
        },
        async login() {
            try{
                if (typeof window.ethereum !== 'undefined') {
                    window.web3 = new Web3(ethereum);
                    await ethereum.enable();
                    const accounts = await web3.eth.getAccounts();
                }
                else{
                    alert('No Ethereum account was found. Plese install a browser extension wallet.');
                }
            }
            catch(error)
            {
                alert(error);
                // this.$bvToast.toast(error, {
                //     title: 'Error',
                //     vriant: 'danger',
                //     solid: true
                // });
            }
        }
      }
    }
  </script>