//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../src/MyToken.sol";
import "../script/DeployMyToken.s.sol";

contract MyTokenTest is Test {

    MyToken public token;
    DeployMyToken public deployer;

    address alice = makeAddr("Alice");
    address bob = makeAddr("Bob");

    uint256 public STARTING_BAL = 100 ether;

    function setUp() public {
    
        deployer = new DeployMyToken();
        token = deployer.run();

        vm.prank(msg.sender);
        token.transfer(bob, STARTING_BAL);

    }

    function testBobBalance() public view {
        assertEq(STARTING_BAL, token.balanceOf(bob), "Bob balance mismatch");
    }


}