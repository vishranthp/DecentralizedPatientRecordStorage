// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./Client.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Physician is AccessControl
{
    bytes32 public constant DOCTOR_ROLE = keccak256("DOCTOR_ROLE");

    Client patient;
    mapping(address => Doctor) Doctors;
    address[] DoctorAddresses;

    struct Doctor{
        uint8 PatientCount;
        string LastName;
        string FirstName;
        string Workplace;
        string Qualification;
    }

    constructor() {
        _grantRole(DOCTOR_ROLE, msg.sender);
    }

    function addDoctor(string memory firstName, string memory lastName, string memory workplace, string memory qualification) public
    {
        Doctor storage doc = Doctors[msg.sender];
        doc.LastName = lastName;
        doc.FirstName = firstName;
        doc.Workplace = workplace;
        doc.Qualification = qualification;
    }

    function getDoctor(address doctorAddress) public view returns (string memory, string memory, string memory, string memory)
    {
        return (
                Doctors[doctorAddress].FirstName,
                Doctors[doctorAddress].LastName,
                Doctors[doctorAddress].Qualification,
                Doctors[doctorAddress].Workplace
            );
    }

    // return if the account belongs to a Doctor
    // doctorAddress: Address of Doctor
    function isDoctor(address doctorAddress) public view returns (bool)
    {
        uint count = DoctorAddresses.length;
        for(uint index = 0; index < count; index++)
        {
            if (DoctorAddresses[index] == doctorAddress)
            {
                return true;
            }
        }

        return false;
    }
}