<template>
    <b-container fluid>
      <b-row class="mt-5">
        <b-col>
            <p class="text-monospace text-center">The patient record is one of the important assets that is currently centralized, maintained, and managed by hospitals. Some countries have moved to Electronic Health Record (EHR), and many countries still follow the old method to store the patient and medical details. Around 80 to 90% of the hospitals in the United States have adopted basic EHR systems, which have a lot of problems related to privacy, security, and ownership of these health records. Even after moving to EHR, the patient record is completely owned and controlled by hospitals, and being the owner of that record, a patient does not have access to the data and has to always reach out to hospitals to get it. Data consolidation is one of the biggest challenges as every hospital stores these EHRs on their server. The patients need to access different EHRs to consolidate their complete medical history. Since hospitals own the EHRs, they have full control and can manipulate the data at any moment. They can even sell the data to research organization and earn a good amount of money. Along with the patient record, doctor authenticity is another challenge that is faced as there is no direct way to check if the doctor is real or not.</p>
        </b-col>
      </b-row>
      <b-row>
        <b-col class="mt-5">
            <p class="text-monospace text-center">Blockchain is a technology designed to manage patient data that has the potential to support transparency and accountability. A blockchain is a ledger of transactions where an identical copy is visible to all the members of a computer network. Network members validate the data entered into the ledger, and once entered, the data is immutable. With the help of Blockchain technology, a solution can be developed to store the EHR of any patient in a distributed and decentralized network. With blockchain solutions, patients can own their data and can approve hospitals, doctors, and research organizations to access their data.</p>
        </b-col>
      </b-row>
      <b-row align-h="center" class="mt-4">
        <b-col class="d-flex justify-content-center" cols="2">
          <b-button variant="success" class="ml-3" @click="login">Log in</b-button>
        </b-col>
        <b-col cols="2">
          <b-button variant="success" class="ml-3" @click="register">Sign Up</b-button>
        </b-col>
      </b-row>
    </b-container>
  </template>

<script>
    import Web3 from 'web3';
    export default {
        data : () => ({
        }),
        methods: {
          register() {
              this.$router.push({name:'register'});
          },
          async login() {
              try{
                  if (typeof window.ethereum !== 'undefined') {
                      window.web3 = new Web3(ethereum);
                      await ethereum.enable();
                      const accounts = await web3.eth.getAccounts();
                      alert(accounts[0]);
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
