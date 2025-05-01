// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CounterV2 {
    uint256 public count;
    address public owner;

    function upgradeTo(address newImplementation) external {
        require(msg.sender == owner, "Not owner");

        bytes32 slot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
        assembly {
            sstore(slot, newImplementation)
        }
    }

    function initialize(address _owner) external {
        require(owner == address(0), "Already initialized");
        owner = _owner;
    }

    function increment() external {
        count += 2; // Changed behavior!
    }

    function reset() external {
        count = 0;
    }

    function getCount() external view returns (uint256) {
        return count;
    }
}