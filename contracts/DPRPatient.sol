// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
// import "@openzeppelin/contracts/access/AccessControl.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract DPRPatient //is ERC20, ERC20Burnable, AccessControl, ERC20Permit, ERC20Votes
{
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PATIENT_ROLE = keccak256("PATIENT_ROLE");
    bytes32 public constant DOCTOR_ROLE = keccak256("DOCTOR_ROLE");

    mapping(address => mapping(uint => PatientDesease)) Diseases;
    mapping(address => mapping(uint8 => mapping(uint8 => Medicene))) Medicenes;
    mapping(address => Patient) Patients;
    mapping(address => Doctor) Doctors;

    struct Patient{
        uint8 Age;
        uint DiseaseCount;

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

    // constructor() ERC20("PatientToken", "DPRS") ERC20Permit("PatientToken") {
    //     _mint(msg.sender, 100000000 * 10 ** decimals());
    //     _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    //     _grantRole(MINTER_ROLE, msg.sender);
    //     _grantRole(PATIENT_ROLE, msg.sender);
    //     _grantRole(DOCTOR_ROLE, msg.sender);
    // }

    // function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
    //     _mint(to, amount);
    // }

    // The following functions are overrides required by Solidity.

    // function _afterTokenTransfer(address from, address to, uint256 amount)
    //     internal
    //     override(ERC20, ERC20Votes)
    // {
    //     super._afterTokenTransfer(from, to, amount);
    // }

    // function _mint(address to, uint256 amount)
    //     internal
    //     override(ERC20, ERC20Votes)
    // {
    //     super._mint(to, amount);
    // }

    // function _burn(address account, uint256 amount)
    //     internal
    //     override(ERC20, ERC20Votes)
    // {
    //     super._burn(account, amount);
    // }

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

    function addPatient(uint8 age, string memory firstName, string memory lastName) public
    {
        Patient storage patient = Patients[msg.sender];
        patient.Age = age;
        patient.LastName = lastName;
        patient.FirstName = firstName;
    }

    function addDisease(address walletAddress, uint8 diseaseID, string memory name, string memory symptoms) public
    {
        Patient memory patient = Patients[walletAddress];
        PatientDesease storage patientDisease = Diseases[walletAddress][patient.DiseaseCount];

        patientDisease.Name = name;
        patientDisease.DiseaseID = diseaseID;
        patientDisease.Symptoms = symptoms;
        patient.DiseaseCount++;
    }

    function addMedicene(address walletAddress, uint8 diseaseID, uint8 mediceneID, string memory name, string memory dose, string memory concentration, uint8 price, uint8 expiryDate) public
    {
        PatientDesease memory patientDisease = Diseases[walletAddress][diseaseID];
        Medicene storage medicene = Medicenes[walletAddress][diseaseID][patientDisease.MediceneCount];

        medicene.Name = name;
        medicene.Dose = dose;
        medicene.Price = price;
        medicene.ID = mediceneID;
        medicene.ExpiryDate = expiryDate;
        medicene.Concentration = concentration;

        patientDisease.MediceneCount++;
    }

    function getPatient(address walletAddress) public view returns (uint8, string memory, string memory)
    {
        return (
        Patients[walletAddress].Age,
        Patients[walletAddress].FirstName,
        Patients[walletAddress].LastName
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
}