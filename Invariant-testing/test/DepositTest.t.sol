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
        deposit.deposit{value: 1 ether}();
        uint256 balanceBefore  = deposit.balances(address(this));

        assertEq(balanceBefore, 1 ether, "Balance before mismatch");

        deposit.withdraw();
        uint256 balanceAfter = deposit.balances(address(this));
        assertGt(balanceBefore, balanceAfter); 
    }

    receive() external payable {}
}