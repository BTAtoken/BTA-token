// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PublicTokenSale is Ownable {
    IERC20 public token;
    uint256 public rate; // Number of tokens per 1 ETH
    bool public saleEnded;

    event TokensPurchased(address indexed buyer, uint256 amount);
    event SaleEnded();

    constructor(IERC20 _token) Ownable(msg.sender) {
        token = _token;
        rate = 10000; // Set the rate to 10,000 tokens per 1 ETH
        saleEnded = false;
    }

    function buyTokens() public payable {
        require(!saleEnded, "Token sale has ended");
        uint256 tokenAmount = msg.value * rate;
        require(token.balanceOf(address(this)) >= tokenAmount, "Not enough tokens in contract");
        token.transfer(msg.sender, tokenAmount);
        emit TokensPurchased(msg.sender, tokenAmount);
    }

    function withdrawETH() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function endSale() public onlyOwner {
        require(!saleEnded, "Sale already ended");
        saleEnded = true;
        token.transfer(owner(), token.balanceOf(address(this)));
        emit SaleEnded();
    }
}
