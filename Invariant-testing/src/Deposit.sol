// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Deposit {
    address public seller = msg.sender;
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        (bool s, ) = msg.sender.call{value: amount}("");
        require(s, "Failed to send");
    }

}
