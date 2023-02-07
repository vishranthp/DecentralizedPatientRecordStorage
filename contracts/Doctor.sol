// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./DPRPatient.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract DPRDoctor is IERC20, ERC20Burnable, AccessControl, ERC20Permit, ERC20Votes
{
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant DOCTOR_ROLE = keccak256("DOCTOR_ROLE");

    DPRPatient patient;
    mapping(address => Doctor) Doctors;
    mapping(address => mapping(uint8 => mapping(uint8 => Medicene))) Medicenes;  

    struct Doctor{
        uint8 PatientCount;
        
        string LastName;
        string FirstName;
        string Workplace;
        string Qualification;
    }

    struct Medicene {
        uint8 ID;
        uint8 Price;
        uint8 ExpiryDate;

        string Dose;
        string Name;
        string Concentration;
    }

    constructor() ERC20("PatientToken", "DPRS") ERC20Permit("PatientToken") {
        _mint(msg.sender, 100000000 * 10 ** decimals());
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
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

    function addDoctor(string memory firstName, string memory lastName, string memory workplace, string memory qualification) public
    {
        Doctor storage doc = Doctors[msg.sender];
        doc.LastName = lastName;
        doc.FirstName = firstName;
        doc.Workplace = workplace;
        doc.Qualification = qualification;
    }

    function getDoctor(address walletAddress) public view returns (string memory, string memory, string memory, string memory)
    {
        return (
                Doctors[walletAddress].FirstName,
                Doctors[walletAddress].LastName,
                Doctors[walletAddress].Qualification,
                Doctors[walletAddress].Workplace
            );
    }

    function prescribeMedicene(address walletAddress, uint8 diseaseID, uint8 mediceneID, string memory name, string memory dose, string memory concentration, uint8 price, uint8 expiryDate) 
    public
    {
        require(msg.sender == walletAddress, "Only Doctor can prescribe");
        uint8 mediceneCount = patient.getMediceneCount(walletAddress, diseaseID);
        Medicene storage medicene = Medicenes[walletAddress][diseaseID][mediceneCount];

        medicene.Name = name;
        medicene.Dose = dose;
        medicene.Price = price;
        medicene.ID = mediceneID;
        medicene.ExpiryDate = expiryDate;
        medicene.Concentration = concentration;

        mediceneCount++;

        patient.updateMediceneCount(walletAddress, diseaseID, mediceneCount);
    }

    function getMedicenes(address walletAddress, uint8 diseaseID) public view returns (Medicene[] memory)
    {
        uint8 mediceneCount = patient.getMediceneCount(walletAddress, diseaseID);
        Medicene[] memory medicenes = new Medicene[](mediceneCount);

        for(uint8 index = 0; index < mediceneCount; index++)
        {
            medicenes[index] = Medicenes[walletAddress][diseaseID][index];
        }

        return medicenes;
    }
}