//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import { Deposit1 } from "../src/Deposit1.sol";

contract Deposit1Test is Test {
    Deposit1 public deposit;
    Deposit1 public faildeposit;
    address constant SELLER = address(0x5E11E7);

    // RejectTransaction private rejector;

    event Deposited(address indexed);
    event SellerWithdraw(address indexed, uint256 indexed);

    function setUp() public {
        deposit = new Deposit1(SELLER);
        
    }

    modifier startAtPresentDay() {
        vm.warp(1680616584);
        _;
    }

    address public buyer = address(this); // the DepositTest contract is the "buyer"
    address public buyer2 = address(0x5E11E1); // random address
    address public FakeSELLER = address(0x5E1222); // random address

    function test_DepositAmount() public startAtPresentDay{
        vm.startPrank(buyer);
        //Deposit1.buyerDeposit{value : 1 ether}();

        vm.expectRevert();
        deposit.buyerDeposit{value: 1.5 ether}();
        
        vm.stopPrank();

    }

    function testBuyerDepositSellerWithdrawAfter3days() public startAtPresentDay {
        vm.startPrank(buyer);
        deposit.buyerDeposit{value : 1 ether}();

        assertEq(address(deposit).balance, 1 ether, "Balance did not increase !!!");

        vm.stopPrank();
        
         // after three days the seller withdraws
        vm.startPrank(SELLER);
        vm.warp(1680616584 + 3 days + 1 seconds);
        
        deposit.sellerWithdraw(address(this));
        vm.stopPrank();

        assertEq(address(deposit).balance, 0 ether, "Balance did not decrease");


    }

    function testBuyerDepositSellerWithdrawBefore3days() public {
        vm.startPrank(buyer);
        deposit.buyerDeposit{value : 1 ether}();

        assertEq(address(deposit).balance, 1 ether, "Balance did not increase !!!");

        vm.stopPrank();
        
         // after three days the seller withdraws
        vm.startPrank(SELLER);
        vm.warp(1680616584 + 2 days);
        
        vm.expectRevert();
        deposit.sellerWithdraw(address(this));
        vm.stopPrank();

    }

    function testUserDepositTwice() public startAtPresentDay {
        vm.startPrank(buyer);
        deposit.buyerDeposit{value : 1 ether}();

        assertEq(address(deposit).balance, 1 ether, "Balance did not increase !!!");

        //tries to buy again , which should revert.abi

        vm.warp(1680616584 + 3 days);

        vm.expectRevert();
        deposit.buyerDeposit{value : 1 ether}();
        //assertEq(address(deposit).balance, 2, "Incorrect balance!!!");
    }

    
}