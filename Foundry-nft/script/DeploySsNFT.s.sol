// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "../src/SsNFT.sol";

contract DeploySsNFT is Script {
    function run() external {
        vm.startBroadcast();
        SsNFT ssNft = new SsNFT();
        vm.stopBroadcast();
    }
}