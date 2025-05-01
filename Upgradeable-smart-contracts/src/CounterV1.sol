// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CounterV1 {
    uint256 public count;
    address public owner;

    function upgradeTo(address _newImplementation) external {
        require(msg.sender == owner, "No Access");
        bytes32 slot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
        assembly {
            sstore(slot, _newImplementation)
        }
    }

    function initialize(address _owner) external {
        require(owner == address(0), "Owner already initialized");
        owner = _owner;
    }

    function increment() external {
        count++;
    }

    function getCount() external view returns (uint256) {
        return count;
    }

}
