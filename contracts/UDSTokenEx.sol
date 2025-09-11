// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract UDSTokenEx is ERC20 {
    uint unitsOneTokenToBuy = 10;   
    address public owner;
event Buy(address indexed from, address indexed to, uint tokens);

    constructor() ERC20("UdsaneeToken", "UDS") {
        owner = msg.sender;
        _mint(address(this), 1000000 * 10 ** decimals());
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Sender is not the owner");
        _ ;
    }

    function buy() payable public {
        require(msg.sender == msg.sender, "Only onlyOwner");  // เช็คว่ามี ETH ที่จะมาแลกมั้ย
        uint amount = msg.value * unitsOneTokenToBuy;
        require (amount > 0, "Too less amount of token");  // เช็คว่ามี Token มากกว่า 0 คือมี UDS Token ให้แลกนะ
        require(balanceOf(address(this)) >= amount, "There is no token left. Sold out!!");
        _transfer(address(this), msg.sender, amount);
        emit Buy(address(this), msg.sender, amount);
    }

    // owner คนที่ deploy contract สามารถ withdraw ETH ได้
    function withdraw(uint amount) public onlyOwner {
        (bool success, ) = msg.sender.call{value: amount}(""); // ส่ง ETH ไปยัง address ของ owner
        require(success, "Failed to send ETH");
        emit Transfer(msg.sender, address(this), amount);
    }
}