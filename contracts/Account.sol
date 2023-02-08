// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract HealthTokenAccount
{
    IERC20 public token;
    address owner;
    uint price;

    constructor(IERC20 _token, uint _price)
    {
        token = _token;
        price = _price;
        owner = msg.sender;
    }

    event Deposit();
    event TransferRequested();
    event Withdraw();
    event AccountCreated();

    struct Agreement
    {
        uint id;
        address patient;
        address doctor;
        uint balance;
    }

    struct Account
    {
        address patient;
        uint balance;
        address[] doctors;
    }

    struct TokenTransferRequest
    {
        address patient;
        address doctor;
        uint amount;
        bool approved;
    }

    uint nextPatientAgreementId;
    uint nextWithdrawId;

    modifier patientAccountOwner(uint accountId)
    {
        bool isOwner;

        _;
    }

    modifier sufficientBalance()
    {
        _;
    }

    modifier canApprove()
    {
        _;
    }

    function getTokenBalance() public view returns (uint)
    {
        return token.balanceOf(address(this));
    }

    function getPatientAgreementBalance() public view returns (bool)
    {
        return false;
    }

    function createAgreement() public returns (uint)
    {
        // take tokens from
        return nextPatientAgreementId++;
    }

    function deposit(uint accountId) external payable patientAccountOwner(accountId)
    {
        uint balance;
        balance += msg.value;
    }

    function requestTransfer() public returns (uint)
    {
        // the doctor requests a transfer of tokens
        return 1;
    }

    function approveTransfer() public returns (uint)
    {
        // the patient approves the request of transfer
        // with a successful transfer of tokens the doctor can prescribe
        return 1;
    }

    function transfer() public returns (uint)
    {
        return 1;
    }

    function getPatientAgreement() public view returns(Agreement memory)
    {
        Agreement memory p;
        return p;
    }
}