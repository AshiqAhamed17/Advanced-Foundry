//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../script/DeployBasicNFT.s.sol";
import "../src/BasicNFT.sol";

contract BasicNFTTest is Test {

    DeployBasicNFT public deployer;
    BasicNFT public basicNft;

    address public user = makeAddr("user");
    string public constant  PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";


    function setUp() public {
        deployer = new DeployBasicNFT();

        basicNft = deployer.run();
    }

    function testName() public view {
        assertEq(basicNft.name(), "Dogie", "Incorrect NFT Name");
    }

    function testMintAndBalance() public {

        vm.prank(user);
        basicNft.mintNFT(PUG);

        assert(basicNft.balanceOf(user) == 1);
        assertEq(basicNft.tokenURI(0), PUG,"TokenURI mismatch");
    }
}