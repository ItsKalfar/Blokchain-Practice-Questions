// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// 	Write a Solidity function to check if a given address is a contract or not.

contract CheckAddress {
    function isContract(address addr) public view returns (string memory) {
        uint32 size;
        assembly {
            size := extcodesize(addr)
        }
        if (size > 0) {
            return "This is a smart contract address";
        } else {
            return "This is a wallet address";
        }
    }
}

// Write a Solidity function to transfer ERC20 tokens from one address to another.
// Works only if the sender has been approved

contract TransferTokens {
    function transferTokens(
        address _token,
        address _to,
        uint256 _value
    ) external {
        require(_to != address(0));
        // Get the token contract instance
        IERC20 tokenContract = IERC20(_token);

        // Check that the sender has enough tokens to transfer
        require(
            tokenContract.balanceOf(msg.sender) >= _value,
            "Insufficient balance"
        );
        // Transfer tokens to the recipient
        require(
            tokenContract.transferFrom(msg.sender, _to, _value),
            "Tx Failed"
        );
    }
}

// Write a Solidity function to withdraw funds from a smart contract.

error NotOwner();
error NotEnoughETH();

contract TransferFunds {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function deposite() external payable {
        (bool sent, ) = payable(address(this)).call{value: msg.value}("");
        require(sent, "Tx Failed");
    }

    function withdraw() external payable {
        if (msg.sender != owner) {
            revert NotOwner();
        }
        if (address(this).balance <= 0) {
            revert NotEnoughETH();
        }
        (bool sent, ) = payable(msg.sender).call{value: address(this).balance}(
            ""
        );
        require(sent, "Tx Failed");
    }

    // Write a Solidity function to check the balance of a given address.
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {}
}
