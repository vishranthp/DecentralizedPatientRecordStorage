<template>
    <b-container fluid>
      <b-row class="mt-5">
        <b-col cols="3">
            <div class="float-end mr-2">Account:</div>
        </b-col>
        <b-col cols="5">
          <div>
            <b-form-select v-model="account" class="mb-3">
                <b-form-select-option :value="null">Please select an account</b-form-select-option>
                <b-form-select-option v-for="acc in accounts" :value="acc">{{ acc }}</b-form-select-option>
            </b-form-select>
            <!-- <b-button v-else size='sm' variant="info" @click="getEthAccount">Get Ethereum Account</b-button> -->
          </div>
        </b-col>
      </b-row>
      <b-row class="mt-3">
        <b-col cols="3">
            <div class="float-end mr-2">Are you patient or doctor?</div>
        </b-col>
        <b-col cols="2">
            <b-form-select v-model="selectedEntity" class="mb-3">
                <b-form-select-option :value="null">Please select an option</b-form-select-option>
                <b-form-select-option value="Patient">Patient</b-form-select-option>
                <b-form-select-option value="Doctor">Doctor</b-form-select-option>
            </b-form-select>
        </b-col>
      </b-row>
      <b-row class="mt-3">
        <b-col cols="3">
            <div class="float-end mr-2">Name:</div>
        </b-col>
        <b-col cols="3">
            <b-form-input size="sm" v-model="firstName" placeholder="First Name" maxlength="50" trim></b-form-input>
        </b-col>
        <b-col cols="3">
            <b-form-input size="sm" v-model="lastName" placeholder="Last Name" maxlength="50" trim></b-form-input>
        </b-col>
      </b-row>
      <b-row class="mt-3">
        <b-col cols="3">
            <div class="float-end mr-2">Age:</div>
        </b-col>
        <b-col cols="1">
            <b-form-input type="number" size="sm" v-model="age" placeholder="Age" trim></b-form-input>
        </b-col>
      </b-row>
      <b-row class="mt-3" v-if="selectedEntity == 'Doctor'">
        <b-col cols="3">
            <div class="float-end mr-2">Qualification:</div>
        </b-col>
        <b-col cols="6">
            <b-form-input size="sm" v-model="qualification" placeholder="Qualification" trim></b-form-input>
        </b-col>
      </b-row>
      <b-row class="mt-3" v-if="selectedEntity == 'Doctor'">
        <b-col cols="3">
            <div class="float-end mr-2">Hospital:</div>
        </b-col>
        <b-col cols="6">
            <b-form-input size="sm" v-model="hospital" placeholder="Hospital" trim></b-form-input>
        </b-col>
      </b-row>
      <b-row class="mt-3">
        <b-col cols="3"></b-col>
        <b-col cols="3">
            <b-button size='sm' variant="info" @click="submit">Submit</b-button>
        </b-col>
      </b-row>
    </b-container>
  </template>

<script>
import Web3 from 'web3';
import patientContract from '../Patient.json';
export default {
  data : () => ({
    age: '',
    account: '',
    hospital: '',
    lastName: '',
    firstName: '',
    qualification: '',

    accounts: [],

    web3: null,
    selectedEntity: null,
    patientContract: null
  }),

  async created() {
    try{
      this.web3 = new Web3(new Web3.providers.HttpProvider(process.env.VUE_APP_ETH_PROVIDER));
      this.accounts = await this.web3.eth.getAccounts();
    }
    catch(error){
      alert(error);
    }
  },
  methods: {
    async getEthAccount() {
        try{
            if (typeof window.ethereum !== 'undefined') {
                this.web3 = new Web3(ethereum);
                await ethereum.enable();
                const accounts = await this.web3.eth.getAccounts();
                if (accounts && accounts.length > 0) {
                    this.account = String(accounts[0]);
                }
            }
            else{
                alert('No Ethereum account was found. Plese install a browser extension wallet.');
            }
        }
        catch(error)
        {
            alert(error);
        }
    },

    validate() {
      
      if(!this.account) {
        alert('Account is required.');
        return false;
      }
      if(!this.selectedEntity) {
        alert('Please select if you are a Patient or Doctor.');
        return false;
      }
      if(!this.firstName) {
        alert('First Name is required.');
        return false;
      }
      if(!this.age) {
        alert('Age is required.');
        return false;
      }

      if(this.selectedEntity == 'Doctor') {
        if(!this.qualification) {
          return false;
        }
        if(!this.hospital) {
          return false;
        }
      }
      return true;
    },

    async submit() {
      try{
        if(this.validate() == false) {
          return;
        }

        this.web3 = new Web3(new Web3.providers.HttpProvider(process.env.VUE_APP_ETH_PROVIDER));
        this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
        this.patientContract = await new this.web3.eth.Contract(patientContract,process.env.VUE_APP_CONTRACT_ADDRESS);

        if(this.selectedEntity == 'Doctor') {
          var address = this.account;

          await this.patientContract.methods.addDoctor(this.age, this.firstName, this.lastName, this.hospital, this.qualification).send(
          {
              from: address, gas: 407035
          }).on('transactionHash', function (hash) {
              alert(hash);
          })
        }
        if(this.selectedEntity == 'Doctor') {
          this.$router.push( { name: 'doctor' } );
        }
        else {
          this.$router.push( { name: 'patient' } );
        }
      }
      catch(error){
        alert(error);
      }
    }
  }
}
</script>