// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/StdInvariant.sol";
import "../../script/DeployDSC.s.sol";
import "../../src/DSCEngine.sol";
import "../../src/DecentralizedStableCoin.sol";
import "../../script/HelperConfig.s.sol";
import "./Handler.t.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract InvariantsTest is StdInvariant, Test {
    DeployDSC deployer;
    DSCEngine dsce;
    DecentralizedStableCoin dsc;
    HelperConfig config;
    address weth;
    address wbtc;
    Handler handler;

    function setUp() public {
        deployer = new DeployDSC();
        (dsc, dsce, config) = deployer.run();
        (, , weth, wbtc, ) = config.activeNetworkConfig();

        handler = new Handler(dsce, dsc);
        targetContract(address(handler));
    }

    function invariant_protocolMustHaveMoreValueThanTotalSupply() public view {
        uint256 totalSupply = dsc.totalSupply();
        uint256 totalWethDeposited = IERC20(weth).balanceOf(address(dsce));
        uint256 totoalWbtcDeposited = IERC20(wbtc).balanceOf(address(dsce));

        uint256 wethValue = dsce.getUsdValue(weth, totalWethDeposited);
        uint256 wbtcValue = dsce.getUsdValue(wbtc, totoalWbtcDeposited);

        console.log("weth value: ", wethValue);
        //console.log("wbtc value: ", wbtcValue);
        console.log("total Supply: ", totalSupply);
        console.log("Times Mint Called: ", handler.timesMintIsCalled());
        assert(wethValue + wbtcValue >= totalSupply);
        
        
    }
}