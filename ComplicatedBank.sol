// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
contract ComplicatedBank {
    uint rate = 3;
    address[] public accounts;
    address public owner;
    mapping(address => uint256) balances;
    constructor() {
        owner = msg.sender;
    }

   modifier onlyOwner() {
        require(msg.sender == owner, "Sender is not the owner");
        _ ;
    }

    function getSystemBalance(address newOwner) public onlyOwner {
        owner = newOwner;
    } 
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function deposit() public payable {

        balances[msg.sender] += msg.value;
        accounts.push(msg.sender); 

    }
    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insuffient money to withdraw!!!");
        balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Withdraw failed!!");
    }

    function calculateInterest(address account) public view returns (uint){
        return balances[account] * rate / 100;
    }

    function totalInterestPerYear() public view returns (uint){
        uint256 total = 0;
         for (uint256 i=0; i<accounts.length; i++){

      address account = accounts[i];

      uint256 interest = calculateInterest(account);
      total += interest;
    }
    return total;
}
}