// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Proxy {
    bytes32 constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    constructor(address _implementation, bytes memory _initData) {
        assembly {
            sstore(IMPLEMENTATION_SLOT, _implementation)
        }

        if(_initData.length > 0) {
            (bool s, ) = _implementation.delegatecall(_initData);
            require(s, "Init Failed");
        }

    }

    fallback() external payable {
        assembly {
            let impl := sload(IMPLEMENTATION_SLOT)
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
                case 0 { revert(0, returndatasize()) }
                default { return(0, returndatasize()) }
        }
    }

    receive() external payable {}
}


