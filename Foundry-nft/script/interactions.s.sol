//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import {BasicNFT} from "../src/BasicNFT.sol";

contract MintBasicNFT is Script {
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

        //ipfs://QmRP1DM7n2mFZSc61KqyGp6c4hDr8v7baPs72wtQPVHiZV => ss.json

    // Store the deployed contract address here or pass it dynamically
    address public basicNftAddress;

    function run() external {
        // Set the deployed contract address here
        basicNftAddress = getDeployedAddress();

        mintNftOnContract(basicNftAddress);
    }

    function getDeployedAddress() internal pure returns (address) {
        // Replace this with the actual deployed contract address
        return 0x90e3320BACb83f402F8E20aEbD97b5F4240dE266; // Deployed PUC address
    }

    function mintNftOnContract(address _basicNftAddress) public {
        vm.startBroadcast();
        BasicNFT(_basicNftAddress).mintNFT(PUG_URI);
        vm.stopBroadcast();
    }
}