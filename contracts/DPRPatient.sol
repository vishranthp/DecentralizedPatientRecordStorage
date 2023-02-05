// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract DPRPatient is ERC20, ERC20Burnable, AccessControl, ERC20Permit, ERC20Votes {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PATIENT_ROLE = keccak256("PATIENT_ROLE");
    bytes32 public constant DOCTOR_ROLE = keccak256("DOCTOR_ROLE");

    struct Patient{
        uint8 Age;
        uint8 DiseaseCount;

        string LastName;
        string FirstName;
    }

    struct Doctor{
        uint8 Age;
        uint8 PatientCount;
        
        string LastName;
        string FirstName;
        string Workplace;
        string Qualification;
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
        uint8 ExpiryDate;

        string Dose;
        string Name;
        string Concentration;
    }

    mapping(address => Patient) Patients;
    mapping(address => mapping(uint8 => PatientDesease)) Diseases;
    mapping(address => Doctor) Doctors;

    constructor() ERC20("PatientToken", "DPRS") ERC20Permit("PatientToken") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(PATIENT_ROLE, msg.sender);
        _grantRole(DOCTOR_ROLE, msg.sender);
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

    function addDoctor(uint8 age, string memory firstName, string memory lastName, string memory workplace, string memory qualification) public
    {
        Doctor storage doc = Doctors[msg.sender];
        doc.Age = age;
        doc.LastName = lastName;
        doc.FirstName = firstName;
        doc.Workplace = workplace;
        doc.Qualification = qualification;
    }

    function getDoctor(address walletAddress) public view returns (uint, string memory, string memory, string memory, string memory)
    {
        return (
                Doctors[walletAddress].Age,
                Doctors[walletAddress].FirstName,
                Doctors[walletAddress].LastName,
                Doctors[walletAddress].Qualification,
                Doctors[walletAddress].Workplace
            );
    }

    
}