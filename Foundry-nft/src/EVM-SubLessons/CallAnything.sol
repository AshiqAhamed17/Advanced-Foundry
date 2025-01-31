//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract CallAnything {
    address public addr;
    uint256 public amount;

    function transfer(address _addr, uint256 _amount) public {
        addr = _addr;
        amount = _amount;
    }

    function getSelectorOne() public pure returns (bytes4 selector) {
        selector = bytes4(keccak256(bytes("transfer(address,uint256)")));
    }

    function getDataToCallTransfer(address _addr, uint256 _amount) public pure returns (bytes memory) {
        return abi.encodeWithSelector(getSelectorOne(), _addr, _amount);
    }

    function callTransferFunctionDirectly(address _addr, uint256 _amount) public returns (bytes4, bool) {
        (bool success, bytes memory data) = address(this).call(
            getDataToCallTransfer(_addr, _amount)
            //abi.encodeWithSelector(getSelectorOne(), _addr, _amount)
        );

        return (bytes4(data), success);
    }

    //using encodWithSignature

    function callTransferFunctionDirectlyTwo(address _addr, uint256 _amount) public returns (bytes4, bool) {
        (bool success, bytes memory data) = address(this).call(
            abi.encodeWithSignature("transfer(address,uint256)", _addr, _amount)
        );

        return (bytes4(data), success);
    }


}
