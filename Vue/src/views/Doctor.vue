<template>
    <b-container fluid>
      <b-row>
        <b-col>
          <div class="d-flex justify-content-center mt-3">
            <H6>Doctor Details</H6>
          </div>
        </b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">
            <div class="float-end">Address:</div>
        </b-col>
        <b-col cols="3">
            <b-form-input size="sm" v-model="account" placeholder="Account" trim></b-form-input>
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
            <div class="float-end">Qualification:</div>
        </b-col>
        <b-col cols="3">
            <div class="mr-2">{{ qualification }}</div>
        </b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">
            <div class="float-end">Hospital:</div>
        </b-col>
        <b-col cols="3">
            <div class="mr-2">{{ hospital }}</div>
        </b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">
            <div class="float-end">
                <b-button size='sm' variant="info" @click="editDoctor">Edit</b-button>
            </div>
        </b-col>
        <b-col cols="3">
            <b-button size='sm' variant="info" @click="getDoctor">Get Details</b-button>
        </b-col>
      </b-row>
      <b-row class="mt-3">
        <b-col>
          <div class="d-flex justify-content-center mt-3">
            <H6>Your Patients</H6>
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

      <b-modal ref="doctorEditModal" hide-footer hide-header size="lg">
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
                <b-col cols="3">
                    <div class="float-end mr-2">Qualification:</div>
                </b-col>
                <b-col cols="3">
                    <b-form-input size="sm" v-model="qualification" placeholder="Qualification" maxlength="50" trim></b-form-input>
                </b-col>
            </b-row>
            <b-row class="mt-3">
                <b-col cols="3">
                    <div class="float-end mr-2">Hospital:</div>
                </b-col>
                <b-col cols="4">
                    <b-form-input size="sm" v-model="hospital" placeholder="Hospital" maxlength="50" trim></b-form-input>
                </b-col>
            </b-row>
            <b-row class="mt-3">
                <div class="d-flex justify-content-end" >
                    <b-col cols="1">
                        <b-button size='sm' variant="info" @click="updateDoctor">Save</b-button>
                    </b-col>
                    <b-col cols="1">
                        <b-button size='sm' variant="info" @click="closeDoctorModal">Close</b-button>
                    </b-col>
                </div>
            </b-row>
        </div>
      </b-modal>
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

    web3: null,
    selectedEntity: null,

    diseases: [],
    headers: [
        { key: 'Disease', label: 'Disease Name', sortable: true},
        { key: 'Symptoms', label: 'Symptoms', sortable: true}
    ]
  }),

  async created() {
    this.web3 = new Web3(new Web3.providers.HttpProvider(process.env.VUE_APP_ETH_PROVIDER));
    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    this.patientContract = await new this.web3.eth.Contract(patientContract,process.env.VUE_APP_CONTRACT_ADDRESS);

    // await this.patientContract.methods.getDoctor(this.account).call().then(function (result) {
    //     this.age = result[0];
    //     this.account = result[1];
    //     this.hospital = result[2];
    //     this.lastName = result[3];
    //     this.firstName = result[4];
    //     this.qualification = result[5];
    // });
    
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
    async getDoctor() {
        try{
            this.web3 = new Web3(new Web3.providers.HttpProvider(process.env.VUE_APP_ETH_PROVIDER));
            this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
            this.patientContract = await new this.web3.eth.Contract(patientContract,process.env.VUE_APP_CONTRACT_ADDRESS);

            var result = await this.patientContract.methods.getDoctor(this.account).call()
            this.age = result[0];
            this.hospital = result[4];
            this.lastName = result[2];
            this.firstName = result[1];
            this.qualification = result[3];
        }
        catch(error)
        {
            alert(error);
        }
    },
    editDoctor() {
        this.$refs['doctorEditModal'].show();
    },
    closeDoctorModal() {
        this.$refs['doctorEditModal'].hide();
    },
    updateDoctor() {
        this.closePatientModal();
    }
  }
}
</script>