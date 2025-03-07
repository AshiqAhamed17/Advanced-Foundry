// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Deposit.sol";

contract DepositTest is Test {
    Deposit deposit;

    function setUp() public {
        deposit = new Deposit();
        vm.deal(address(deposit), 100 ether);
    }

    function invariant_alwaysWithdrawable() public {
        address user = address(0xaa);
        vm.startPrank(user);
        vm.deal(user, 10 ether);

        deposit.deposit{value: 1 ether}();
        uint256 balanceBefore  = deposit.balances(user);
        vm.stopPrank();

        assertEq(balanceBefore, 1 ether, "Balance before mismatch");

        vm.prank(user);
        deposit.withdraw();
        uint256 balanceAfter = deposit.balances(user);
        vm.stopPrank();
        assertGt(balanceBefore, balanceAfter); 
    }

    receive() external payable {}
}