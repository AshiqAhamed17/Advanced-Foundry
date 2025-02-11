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
        (bool success, ) = payable(address(vault)).call{value: 1e18}("");
        require(success, "Error in calling low-level call function");
        vm.stopPrank();
    }

    function testDepositLinear(uint amount) public {
        amount = bound(amount, 1e5, type(uint96).max);
        vm.startPrank(user);
        vm.deal(user, amount);

        vm.stopPrank();
    }


}
