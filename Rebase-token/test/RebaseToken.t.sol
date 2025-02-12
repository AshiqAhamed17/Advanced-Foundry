//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/RebaseToken.sol";
import "../src/Vault.sol";

import { IRebaseToken } from "../src/interfaces/IRebaseToken.sol";

contract RebaseTokenTest is Test {
    RebaseToken private rebaseToken;
    Vault private vault;

    address public owner = makeAddr("owner");
    address public user = makeAddr("user");

    function setUp() public {
        vm.startPrank(owner);
        rebaseToken = new RebaseToken();
        vault = new Vault(IRebaseToken(address(rebaseToken)));
        rebaseToken.grantMintAndBurnRole(address(vault));
        vm.stopPrank();
    }

    function addRewardsToVault(uint256 rewardAmount) public {
        (bool success, ) = payable(address(vault)).call{value: rewardAmount}("");
    }

    function testDepositLinear(uint amount) public {
        amount = bound(amount, 1e5, type(uint96).max);
        vm.startPrank(user);
        // 1. Deposit
        vm.deal(user, amount);
        vault.deposit{value: amount}();
        // 2. Check our rebase Token balance
        uint256 startBalance = rebaseToken.balanceOf(user);
        console.log("Current timestamp: ", block.timestamp);
        console.log("Starting balance: ", startBalance);

        //3. Wrap the time and check the balance again
        vm.warp(block.timestamp + 1 hours);
        console.log("Current timestamp: ", block.timestamp);
        uint256 middleBalance = rebaseToken.balanceOf(user);
        console.log("Middle balance: ", middleBalance);
        assertGe(middleBalance, startBalance);

        // 4. warp the time again by the same amount and check the balance again
        vm.warp(block.timestamp + 1 hours);
        console.log("Current timestamp: ", block.timestamp);
        uint256 endBalance = rebaseToken.balanceOf(user);
        console.log("End balance: ", endBalance);
        assertGe(endBalance, middleBalance);

        // 5. Check the difference of the balances between middle and end balances are the same as the difference between start and middle -> as it is linear.
        assertApproxEqAbs(endBalance - middleBalance, middleBalance - startBalance, 1);

        vm.stopPrank();
    }

    function testRedeemStraightAway(uint256 amount) public {
        amount = bound(amount, 1e5, type(uint96).max);
        // 1. Deposit
        vm.startPrank(user);
        vm.deal(user, amount);
        vault.deposit{value: amount}();
        assertEq(rebaseToken.balanceOf(user), amount, "Balance Mismatch");

        //2 . Redeem
        vault.redeem(type(uint256).max);
        assertEq(rebaseToken.balanceOf(user), 0, "Balance Mismatch");
        assertEq(address(user).balance, amount);
        vm.stopPrank();

    }

    function testRedeemAfterTimeHasPassed(uint256 depositAmount, uint256 time) public {

        depositAmount = bound(depositAmount, 1e5, type(uint96).max);
        time = bound(time, 1000, type(uint96).max);

        // Deposit Funds
        vm.deal(user, depositAmount);
        vm.prank(user);
        vault.deposit{value: depositAmount}();

        // check the balance has increased after some time has passed
        vm.warp(time);

         // Get balance after time has passed
        uint256 balance = rebaseToken.balanceOf(user);
         // Add rewards to the vault


    }


}
