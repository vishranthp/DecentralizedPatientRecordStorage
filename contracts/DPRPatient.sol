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

    function addPatient(uint8 age, string memory firstName, string memory lastName) public
    {
        Patient storage patient = Patients[msg.sender];
        patient.Age = age;
        patient.LastName = lastName;
        patient.FirstName = firstName;
    }

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

    function getMediceneCount(address walletAddress, uint8 diseaseID) public view returns (uint8)
    {
        PatientDesease memory patientDisease = Diseases[walletAddress][diseaseID];
        return patientDisease.MediceneCount;
    }

    function updateMediceneCount(address walletAddress, uint8 diseaseID, uint8 count) public
    {
        PatientDesease storage patientDisease = Diseases[walletAddress][diseaseID];
        patientDisease.MediceneCount = count;
    }
}