// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract B {
    // Storage layout must be same in both the contracts
    uint256 public num;
    address public sender;
    
    function setNum(uint256 _num) public {
        num = _num;
        sender = msg.sender;
    }

}

contract A {
    
    uint256 public num;
    address public sender;

    event DelegateResponse(bool success, bytes data);
    function setDelegatecall(address _contract, uint256 _num) public {
        // A's storage is set; B's storage is not modified.
        (bool success, bytes memory returndata) = _contract.delegatecall(
            abi.encodeWithSignature("setNum(uint256)", _num)
        );
        emit DelegateResponse(success, returndata);
    }
}