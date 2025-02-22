// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../../src/DSCEngine.sol";
import "../../src/DecentralizedStableCoin.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
//import { MockV3Aggregator } from "../mocks/MockV3Aggregator.sol";



contract Handler is Test {
    DSCEngine dsce;
    DecentralizedStableCoin dsc;
    ERC20Mock weth;
    ERC20Mock wbtc;
    uint256 public constant MAX_DEPOSIT_SIZE = type(uint96).max;
    uint256 public timesMintIsCalled;
    address[] usersWithCollateralDeposited;
    //MockV3Aggregator public ethUsdPriceFeed;
    
    constructor (DSCEngine _desc, DecentralizedStableCoin _dsc) {
        dsce = _desc;
        dsc = _dsc;

        address[] memory collateralTokens = dsce.getCollateralTokens();
        weth = ERC20Mock(collateralTokens[0]);
        wbtc = ERC20Mock(collateralTokens[1]);
        

    }

    // Redeem Collateral
    function depositCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
        amountCollateral = bound(amountCollateral, 1, MAX_DEPOSIT_SIZE);
        ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);

        vm.startPrank(msg.sender);
        collateral.mint(msg.sender, amountCollateral);
        collateral.approve(address(dsce), amountCollateral);
        dsce.depositCollateral(address(collateral), amountCollateral);
        vm.stopPrank();

        usersWithCollateralDeposited.push(msg.sender);
    }

    function redeemCollateral(uint256 collateralSeed, uint256 collateralAmount) public {
        ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);
        uint256 maxCollateralToRedeem = dsce.getCollateralBalanceOfUser(address(collateral), msg.sender);

        collateralAmount = bound(collateralAmount, 0, maxCollateralToRedeem);
        if(collateralAmount == 0) {
            return;
        }

        dsce.redeemCollateral(address(collateral), collateralAmount);

    }

    function mintDsc(uint256 amount, uint256 addressSeed) public {

        if(usersWithCollateralDeposited.length == 0){
            return;
        }

        address sender = usersWithCollateralDeposited[addressSeed % usersWithCollateralDeposited.length];
        (uint256 totalDscMinted, uint256 collateralValueInUsd) = dsce.getAccountInformation(sender);

        uint256 maxDscToMint = (collateralValueInUsd / 2) - totalDscMinted;
        if (maxDscToMint < 0) {
            return;
        }

        amount = bound(amount, 0, maxDscToMint);
        if (amount <= 0) {
            return;
        }

        vm.startPrank(sender);
        dsce.mintDSC(amount);
        vm.stopPrank();

        timesMintIsCalled++;
}

    //////////////////////////
    //  Helper Functions   //
    /////////////////////////

    function _getCollateralFromSeed(uint256 collateralSeed) private view returns (ERC20Mock) {
        if(collateralSeed % 2 == 0) {
            return weth;
        }
        return wbtc;
    }

}