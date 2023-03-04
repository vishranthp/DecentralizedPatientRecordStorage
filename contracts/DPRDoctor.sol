// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract DPRDoctor
{
    mapping(address => Doctor) Doctors;
    address[] DoctorAddresses;

    struct Doctor{
        uint8 PatientCount;
        
        string LastName;
        string FirstName;
        string Workplace;
        string Qualification;
    }

    // Add a doctor
    function addDoctor(string memory firstName, string memory lastName, string memory workplace, string memory qualification) public
    {
        Doctor storage doc = Doctors[msg.sender];
        doc.LastName = lastName;
        doc.FirstName = firstName;
        doc.Workplace = workplace;
        doc.Qualification = qualification;
        DoctorAddresses.push(msg.sender);
    }

    // return details of the doctor
    // walletAddress: Address of Doctor
    function getDoctor(address walletAddress) public view returns (string memory, string memory, string memory, string memory)
    {
        return (
                Doctors[walletAddress].FirstName,
                Doctors[walletAddress].LastName,
                Doctors[walletAddress].Qualification,
                Doctors[walletAddress].Workplace
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