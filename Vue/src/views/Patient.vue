<template>
    <b-container fluid>
      <b-row>
        <b-col>
          <div class="d-flex justify-content-center mt-3">
            <H6>Patient Details</H6>
          </div>
        </b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">
            <div class="float-end">Address:</div>
        </b-col>
        <b-col cols="3">
            <div class="mr-2">{{ account }}</div>
        </b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">
            <div class="float-end">Name:</div>
        </b-col>
        <b-col cols="3">
            <div class="mr-2">{{ firstName + ' ' + lastName }}</div>
        </b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">
            <div class="float-end">Age:</div>
        </b-col>
        <b-col cols="3">
            <div class="mr-2">{{ age }}</div>
        </b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">
            <div class="float-end">
                <b-button size='sm' variant="info" @click="editPatient">Edit</b-button>
            </div>
        </b-col>
      </b-row>
      <b-row class="mt-3">
        <b-col>
          <div class="d-flex justify-content-center mt-3">
            <H6>Your Diseases</H6>
          </div>
        </b-col>
      </b-row>
      <b-row>
        <b-col>
            <div class="d-flex justify-content-center mt-3">
                <b-table :items="diseases" :fields="headers" head-row-variant='secondary' label-sort-asc="" label-sort-desc=""
                    responsive hover outlined small sort-icon-left sticky-headers="50vh" style="font-size:10pt;">
                </b-table>
            </div>
        </b-col>
      </b-row>

      <b-modal ref="patientEditModal" hide-footer hide-header size="lg">
        <div class="d-block text-center">
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
                <b-col cols="2">
                    <b-form-input type="number" size="sm" v-model="age" placeholder="Age"></b-form-input>
                </b-col>
            </b-row>
            <b-row class="mt-3">
                <div class="d-flex justify-content-end" >
                    <b-col cols="1">
                        <b-button size='sm' variant="info" @click="updatePatient">Save</b-button>
                    </b-col>
                    <b-col cols="1">
                        <b-button size='sm' variant="info" @click="closePatientModal">Close</b-button>
                    </b-col>
                </div>
            </b-row>
        </div>
      </b-modal>
    </b-container>
  </template>

<script>
import Web3 from 'web3';

export default {
  data : () => ({
    age: '',
    account: '',
    lastName: '',
    firstName: '',

    web3: null,
    selectedEntity: null,

    diseases: [],
    headers: [
        { key: 'Disease', label: 'Disease Name', sortable: true},
        { key: 'Symptoms', label: 'Symptoms', sortable: true}
    ]
  }),

  created() {
    this.age = window.localStorage.getItem('age');
    this.account = window.localStorage.getItem('account');;
    this.lastName = window.localStorage.getItem('lastname');;
    this.firstName = window.localStorage.getItem('firstname');;
    
    this.diseases.push( { Disease: 'Flu', Symptoms: 'fever, cough'} );
    this.diseases.push( { Disease: 'knee pain', Symptoms: 'knee pain'} );
  },

  methods: {
    async getEthAccount() {
        try{
            if (typeof window.ethereum !== 'undefined') {
                web3 = new Web3(ethereum);
                await ethereum.enable();
                const accounts = await web3.eth.getAccounts();
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
    editPatient() {
        this.$refs['patientEditModal'].show();
    },
    closePatientModal() {
        this.$refs['patientEditModal'].hide();
    },
    updatePatient() {
        this.closePatientModal();
    }
  }
}
</script>