// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BTAToken is ERC20, Ownable {

    uint256 public totalSupplyCap;

    constructor(uint256 cap) ERC20("Building the Apartments", "BTA") Ownable(msg.sender) {
        // Set the initial supply to 500,000 tokens with 18 decimal places
        uint256 initialSupply = 500000 * 10**decimals(); 
        require(initialSupply <= cap * 10**decimals(), "Initial supply exceeds cap");
        _mint(msg.sender, initialSupply);
        totalSupplyCap = cap * 10**decimals();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(totalSupply() + amount <= totalSupplyCap, "Cap exceeded");
        _mint(to, amount);
    }

    function burn(uint256 amount) public onlyOwner {
        _burn(msg.sender, amount);
    }

    function distributeProfits(address[] memory recipients, uint256[] memory amounts) public onlyOwner {
        require(recipients.length == amounts.length, "Mismatched arrays");
        for (uint256 i = 0; i < recipients.length; i++) {
            _transfer(owner(), recipients[i], amounts[i]);
        }
    }
}
