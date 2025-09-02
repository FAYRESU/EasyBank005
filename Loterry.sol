// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Lottery { 
    address public manager;
    uint public totalParticipant; 
    uint public winnerIndex;
    address public winnerPlayer;
    address[] public players;
    
 constructor(){
       manager = msg.sender;
   }
    
    function enter() payable public{
    require(msg.value >= 0.005 ether, "Minimum value is 0.01 ether");
       players.push(msg.sender);
       totalParticipant = players.length;
    }

    function pickWinner() public{
        require(msg.sender == manager, "Only official"); 
        uint index = random()% players.length;
        winnerIndex = index;
        (bool success,) = players[index].call{value:(address(this).balance)}("");
        require(success, "Transfer failed");
        winnerPlayer = players[index];
        players =  new address [](0);
        }
    
    function random() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players)));
    }
}