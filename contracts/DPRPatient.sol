// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./Doctor.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract DPRPatient is IERC20, ERC20Burnable, AccessControl, ERC20Permit, ERC20Votes
{
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PATIENT_ROLE = keccak256("PATIENT_ROLE");

    mapping(address => Patient) Patients;
    mapping(address => mapping(uint => PatientDesease)) Diseases;
    mapping(address => mapping(uint8 => mapping(uint8 => Medicene))) Medicenes;

    struct Patient{
        uint8 Age;
        uint DiseaseCount;
        string LastName;
        string FirstName;
    }

    struct PatientDesease {
        uint8 DiseaseID;
        uint8 MediceneCount;
        string Name;
        string Symptoms;
    }

    struct Medicene {
        uint8 ID;
        uint8 Price;
        uint ExpiryDate;
        string Dose;
        string Name;
        string Concentration;
    }

    constructor() ERC20("PatientToken", "DPRS") ERC20Permit("PatientToken") {
        _mint(msg.sender, 100000000 * 10 ** decimals());
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(PATIENT_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }

    // Add a Patient
    function addPatient(uint8 age, string memory firstName, string memory lastName) public
    {
        Patient storage patient = Patients[msg.sender];
        patient.Age = age;
        patient.LastName = lastName;
        patient.FirstName = firstName;
    }

    // Add  Disease
    // walletAddress: Address of Patient
    // Rest are details of disease
     function addDisease(address walletAddress, uint8 diseaseID, string memory name, string memory symptoms)
     public
     {
         require(msg.sender == walletAddress, "Only owner can add");
         Patient storage patient = Patients[walletAddress];         
         PatientDesease storage patientDisease = Diseases[walletAddress][patient.DiseaseCount];
         patientDisease.Name = name;
         patientDisease.Symptoms = symptoms;
         patientDisease.DiseaseID = diseaseID;
         patient.DiseaseCount ++;
     }

    // Get Patient details
    // walletAddress: Address of Patient
    function getPatient(address walletAddress) public view returns (uint8, string memory, string memory, uint)
    {
        Patient memory patient = Patients[walletAddress];
        return (
            patient.Age,
            patient.FirstName,
            patient.LastName,
            patient.DiseaseCount
        );
    }

    // Get list of Diseases for a Patient
    // walletAddress: Address of Patient
    function getDiseases(address walletAddress) public view returns (PatientDesease[] memory)
    {
        uint diseaseCount = Patients[walletAddress].DiseaseCount;
        PatientDesease[] memory diseases = new PatientDesease[](diseaseCount);
        for(uint index = 0; index < diseaseCount; index++)
        {
            diseases[index] = Diseases[walletAddress][index];
        }
        return diseases;
    }

    // Get a particular disease for a Patient
    // walletAddress: Address of Patient
    // diseaseID: ID of the disease
    function getDisease(address walletAddress, uint8 diseaseID) public view returns (PatientDesease memory)
    {
        return Diseases[walletAddress][diseaseID];
    }

    // Get the Medicene count of a patient for a disease
    // walletAddress: Address of Patient
    // diseaseID: ID of the disease
    function getMediceneCount(address walletAddress, uint8 diseaseID) public view returns (uint8)
    {
        return Diseases[walletAddress][diseaseID].MediceneCount;
    }

    // Increment the Medicene count of a patient for a disease
    // walletAddress: Address of Patient
    // diseaseID: ID of the disease
    function updateMediceneCount(address walletAddress, uint8 diseaseID) public returns (uint8)
    {
        return Diseases[walletAddress][diseaseID].MediceneCount++;
    }

    // Get the list of medicenes for a patient.
    // walletAddress: Address of Patient whose details have to be fetched
    // diseaseID: The Disease ID for which the Medicenes have to be fetched
    function getMedicenes(address patientAddress, uint8 diseaseID) external view returns (Medicene[] memory)
    {
        uint8 mediceneCount = Diseases[patientAddress][diseaseID].MediceneCount;
        Medicene[] memory medicenes = new Medicene[](mediceneCount);
        for(uint8 index = 0; index < mediceneCount; index++)
        {
            medicenes[index] = Medicenes[patientAddress][diseaseID][index];
        }
        return medicenes;
    }

    // Doctor Prescribes Medicene to a patient.
    // doctorContract: Address of Doctor contract
    // doctorAddress: Address of Doctor
    // patientAddress: Address of Patient to whom Medicene has to be prescribed
    // diseaseID: The Disease ID for which the Medicenes have to be added
    // Rest are details of Medicene
    function prescribeMedicene(address doctorContract, address doctorAddress, address patientAddress, uint8 diseaseID, uint8 mediceneID, string memory name, string memory dose, string memory concentration, uint8 price, uint expiryDate) 
    public
    {
        if (DPRDoctor(doctorContract).isDoctor(doctorAddress) == false)
        {
            revert("Only a Dcotor can prescribe Medicene.");
        }
        uint8 mediceneCount = Diseases[patientAddress][diseaseID].MediceneCount;
        Medicene storage medicene = Medicenes[patientAddress][diseaseID][mediceneCount];

        medicene.Name = name;
        medicene.Dose = dose;
        medicene.Price = price;
        medicene.ID = mediceneID;
        medicene.ExpiryDate = expiryDate;
        medicene.Concentration = concentration;

        Diseases[patientAddress][diseaseID].MediceneCount++;
    }
}