// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./Physician.sol";
import "./Account.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Client is AccessControl
{
    event PatientCreated(); //new tokens assigned
    event DoctorEstablished(); // tokens handed over
    event DiseaseAdded(); // token redeemed
    event MedicinePrescribed(); // token redeemed
    
    bytes32 public constant PATIENT_ROLE = keccak256("PATIENT_ROLE");

    mapping(address => Patient) Patients;
    mapping(address => mapping(uint => PatientDisease)) Diseases;
    mapping(address => mapping(uint8 => mapping(uint8 => Medicine))) Medicines;
    // mapping(address => mapping(uint8 => Medicene)) Medicenes;
    

    struct Patient{
        uint8 Age;
        uint DiseaseCount;
        string LastName;
        string FirstName;
    }

    struct PatientDisease {
        uint8 DiseaseID;
        uint8 MedicineCount;
        string Name;
        string Symptoms;
    }

    struct Medicine {
        uint8 MedicineID;
        uint8 Price;
        uint8 ExpiryDate;
        string Dose;
        string Name;
        string Concentration;
    }

    constructor()
    {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PATIENT_ROLE, msg.sender);
    }

    modifier canPrescribe(address doctorAddress)
    {
        // validate that the doctor is assigned to the patient
        // validate that the doctor is treating the disease
        _;
    }

    modifier isPatient(address patientAddress)
    {
        // validate that the patient exists
        _;
    }

    modifier sufficentBalance()
    {
        // before assigning a token to a doctor
        // patient needs a sufficient balance
        _;
    }

    function addPatient(address patientAddress, uint8 age, string memory firstName, string memory lastName) public
    {
        // msg.sender
        Patient storage patient = Patients[patientAddress];
        patient.Age = age;
        patient.LastName = lastName;
        patient.FirstName = firstName;

        // give tokens to new patient
    }

     function addDisease(address patientAddress, uint8 diseaseID, string memory name, string memory symptoms)
     public
     {
         require(msg.sender == patientAddress, "Only owner can add");
         Patient storage patient = Patients[patientAddress];         
         PatientDisease storage patientDisease = Diseases[patientAddress][patient.DiseaseCount];

         patientDisease.Name = name;
         patientDisease.Symptoms = symptoms;
         patientDisease.DiseaseID = diseaseID;
         patient.DiseaseCount ++;
     }

    function getPatient(address patientAddress) public view returns (uint8, string memory, string memory, uint)
    {
        Patient memory patient = Patients[patientAddress];
        return (
            patient.Age,
            patient.FirstName,
            patient.LastName,
            patient.DiseaseCount
        );
    }

    function getDiseases(address patientAddress) public view returns (PatientDisease[] memory)
    {
        uint diseaseCount = Patients[patientAddress].DiseaseCount;
        PatientDisease[] memory diseases = new PatientDisease[](diseaseCount);

        for(uint index = 0; index < diseaseCount; index++)
        {
            diseases[index] = Diseases[patientAddress][index];
        }

        return diseases;
    }

    function getMedicineCount(address patientAddress, uint8 diseaseID) public view returns (uint8)
    {
        PatientDisease memory patientDisease = Diseases[patientAddress][diseaseID];
        return patientDisease.MedicineCount;
    }

    function updateMedicineCount(address patientAddress, uint8 diseaseID, uint8 count) public
    {
        PatientDisease storage patientDisease = Diseases[patientAddress][diseaseID];
        patientDisease.MedicineCount = count;
    }


    function prescribeMedicine(address patientAddress, uint8 diseaseID, uint8 medicineID, string memory name, string memory dose, string memory concentration, uint8 price, uint8 expiryDate) 
    public
    {
        require(msg.sender == patientAddress, "Only Doctor can prescribe");
        uint8 medicineCount = getMedicineCount(patientAddress, diseaseID);
        Medicine storage medicine = Medicines[patientAddress][diseaseID][medicineCount];

        medicine.Name = name;
        medicine.Dose = dose;
        medicine.Price = price;
        medicine.MedicineID = medicineID;
        medicine.ExpiryDate = expiryDate;
        medicine.Concentration = concentration;

        medicineCount++;

        updateMedicineCount(patientAddress, diseaseID, medicineCount);
    }

    function getMedicines(address patientAddress, uint8 diseaseID) public view returns (Medicine[] memory)
    {
        uint8 medicineCount = getMedicineCount(patientAddress, diseaseID);
        Medicine[] memory medicines = new Medicine[](medicineCount);

        for(uint8 index = 0; index < medicineCount; index++)
        {
            medicines[index] = Medicines[patientAddress][diseaseID][index];
        }

        return medicines;
    }
}