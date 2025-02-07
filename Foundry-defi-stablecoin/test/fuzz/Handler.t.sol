// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../../src/DSCEngine.sol";
import "../../src/DecentralizedStableCoin.sol";

contract Handler is Test {
    DSCEngine dsce;
    DecentralizedStableCoin dsc;
    
    constructor (DSCEngine _desc, DecentralizedStableCoin _dsc) {
        dsce = _desc;
        dsc = _dsc;
    }

    // Redeem Collateral
    

}