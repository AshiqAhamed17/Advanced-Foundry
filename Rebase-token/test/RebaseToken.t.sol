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
        vm.deal(owner, balance - depositAmount);
        vm.prank(owner);
        addRewardsToVault(balance - depositAmount);

        // Redeem
        vm.prank(user);
        vault.redeem(balance);

        uint256 ethBalance = address(user).balance;

        assertEq(balance, ethBalance, "Balance Mismatch");
        assertGe(balance, depositAmount, "Balance Mismatch");

    }

    function testTransfer(uint256 amount, uint256 amountToSend) public {
        amount = bound(amount, 1e5 + 1e3, type(uint96).max);
        amountToSend = bound(amountToSend, 1e5, amount - 1e3);

        vm.deal(user, amount);
        vm.prank(user);
        vault.deposit{value: amount}();

        address userTwo = makeAddr("userTwo");
        uint256 userBalance = rebaseToken.balanceOf(user);
        uint256 userTwoBalance = rebaseToken.balanceOf(userTwo);
        assertEq(userBalance, amount);
        assertEq(userTwoBalance, 0);

        uint256 initialInterestRate = rebaseToken.getInterestRate();
        assertEq(initialInterestRate, 5e10);

        // Update the interest rate so we can check the user interest rates are different after transferring.
        vm.prank(owner);
        rebaseToken.setInterestRate(4e10);

        // Send half the balance to another user
        vm.prank(user);
        rebaseToken.transfer(userTwo, amountToSend);
        uint256 userBalanceAfterTransfer = rebaseToken.balanceOf(user);
        uint256 userTwoBalancAfterTransfer = rebaseToken.balanceOf(userTwo);
        assertEq(userBalanceAfterTransfer, userBalance - amountToSend);
        assertEq(userTwoBalancAfterTransfer, userTwoBalance + amountToSend);

    }

    function testCannotMintAndBurn() public {
        vm.prank(user);
        vm.expectRevert();
        rebaseToken.mint(user, 1000);

        vm.expectRevert();
        rebaseToken.burn(user, 1000);


    }

    function testCannotSetInterestRate(uint256 newInterestRate) public {
        vm.prank(user);
        vm.expectRevert();
        rebaseToken.setInterestRate(newInterestRate);
    }

    function testGetPrincipleAmount(uint256 amount) public {
        amount = bound(amount, 1e5, type(uint96).max);
        vm.deal(user, amount);
        vm.prank(user);
        vault.deposit{value: amount}();

        assertEq(rebaseToken.principalBalanceOf(user), amount);

        vm.warp(block.timestamp + 1 hours);
        assertEq(rebaseToken.principalBalanceOf(user), amount);
    }

    function testInitialInterestRate() public view{
    uint256 initialRate = rebaseToken.getInterestRate();
    console.log("Initial Interest Rate:", initialRate);
    assertEq(initialRate, 5e10); // ✅ Should match expected value
}


}
