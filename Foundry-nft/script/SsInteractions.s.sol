// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "../src/SsNFT.sol";


contract SsInteractions is Script {

    string public constant SS_URI = "ipfs://QmNpoXN9nBqsycm8HbJfiBQaktuMhtwwNC1G58dvcy9Hhn?filename=0-img15.json";
    address public nftContract = 0x54C9d18D47AD3949D3cF0457973aAf793F3E092b;

    function run() external {
        vm.startBroadcast();
        SsNFT(nftContract).mintNFT(msg.sender, SS_URI);
        vm.stopBroadcast();
    }
    
}