// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "../src/SsNFT.sol";


contract SsInteractions is Script {

    string public constant SS_URI = "ipfs://QmNpoXN9nBqsycm8HbJfiBQaktuMhtwwNC1G58dvcy9Hhn";
    address public nftContract = 0x169F628508A719908836BCB35b5A58A6C660A9ff;

    function run() external {
        vm.startBroadcast();
        SsNFT(nftContract).mintNFT(msg.sender, SS_URI);
        vm.stopBroadcast();
    }
    
}