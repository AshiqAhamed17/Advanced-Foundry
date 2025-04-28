// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {A, B} from "../src/DelegateCall.sol";
import "forge-std/Test.sol";

contract DelegateCallTest is Test {
    A a;
    B b;

    address user = vm.addr(1);

    function setUp() public {
        a = new A();
        b = new B();

    }

    function test_setDelegatecall(uint256 _num) public {
        vm.prank(user);
        a.setDelegatecall(address(b), _num);

        assertEq(a.num(), _num);
        assertEq(a.sender(), user);
    }

}