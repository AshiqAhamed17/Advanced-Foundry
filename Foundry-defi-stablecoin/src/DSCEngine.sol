// SPDX-License-Identifier: MIT

// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions


pragma solidity ^0.8.18;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { DecentralizedStableCoin } from "./DecentralizedStableCoin.sol";
import { AggregatorV3Interface } from "@chainlink/contracts/interfaces/AggregatorV3Interface.sol";
//import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";




/*
 * @title DSCEngine
 * @author Ashiq Ahamed
 *
 * The system is designed to be as minimal as possible, and have the tokens maintain a 1 token == $1 peg at all times.
 * This is a stablecoin with the properties:
 * - Exogenously Collateralized
 * - Dollar Pegged
 * - Algorithmically Stable
 *
 * It is similar to DAI if DAI had no governance, no fees, and was backed by only WETH and WBTC.
 *
 * Our DSC system should always be "overcollateralized". At no point, should the value of
 * all collateral < the $ backed value of all the DSC.
 *
 * @notice This contract is the core of the Decentralized Stablecoin system. It handles all the logic
 * for minting and redeeming DSC, as well as depositing and withdrawing collateral.
 * @notice This contract is based on the MakerDAO DSS system
 */

contract DSCEngine {

    ///////////////////
    //     Errors    //
    ///////////////////

    error DSCEngine__TokenAddressesAndPriceFeedAddressesAmountsDontMatch();
    error DSCEngine__NeedsMoreThanZero();
    error DSCEngine__TokenNotAllowed(address token);
    error DSCEngine__TransferFailed();

     ///////////////////
    // State Variables/
    ///////////////////

    DecentralizedStableCoin private immutable i_dsc;
    mapping(address token => address priceFeed) private s_priceFeeds;
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;
    mapping(address user => uint256 amountDscMinted) private s_DSCMinted;
    address[] private s_collateralTokens;

    uint256 private constant PRECISION = 1e18;
    uint256 private constant ADDITIONAL_FEED_PRECISION = 1e10;

    ///////////////////
    //    Events     //
    ///////////////////

    event CollateralDeposited(address indexed user, address indexed token, uint256 indexed amount);

    //////////////////
    //   Modifiers  //
    //////////////////

    modifier moreThanZero(uint256 amount) {
        if(amount <= 0) {
            revert DSCEngine__NeedsMoreThanZero();
        }
        
        _;
    }

    modifier isAllowedToken(address token) {
        if(s_priceFeeds[token] == address(0)) {
            revert DSCEngine__TokenNotAllowed(token);
        }

        _;
    }


    ///////////////////
    //   Functions   //
    ///////////////////

    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__TokenAddressesAndPriceFeedAddressesAmountsDontMatch();
        }

        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
            s_collateralTokens.push(tokenAddresses[i]);
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }


    ////////////////////////
    // External Functions //
    ///////////////////////

    /*
     * @param tokenCollateralAddress: The ERC20 token address of the collateral you're depositing
     * @param amountCollateral: The amount of collateral you're depositing
     */


    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external moreThanZero(amountCollateral) isAllowedToken(tokenCollateralAddress)  {

            s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
            emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);

            bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);
            if(!success) {
                revert DSCEngine__TransferFailed();
            }
    }

    /* @param amountDscToMint: The amount of DSC you want to mint
     * You can only mint DSC if you have enough collateral
     */

    function mintDSC(uint256 amountDscToMint) public moreThanZero(amountDscToMint) {
        s_DSCMinted[msg.sender] += amountDscToMint;
    }


     /////////////////////////////////////////////
    // Private & Internal View & Pure Functions /
    /////////////////////////////////////////////


    function _revertIfHealthFactorIsBroken(address user) internal view {}


    /*
    * Returns how close to liquidation a user is.
    * If a user goes below 1 they can be liquidated.
    */
    function _healthFactor(address user) private view returns (uint256) {
        (uint256 totalDscMinted, uint256 collateralValueInUsd) = _getAccountInformation(user);
    }

    function _getAccountInformation(address user) private view returns (uint256 totalDscMinted, uint256 collateralValueInUsd) {
        totalDscMinted = s_DSCMinted[user];
        collateralValueInUsd = getAccountCollateralValue(user);
    }



   //////////////////////////////////////////////////////
   //// External & Public View & Pure Functions     ////
   /////////////////////////////////////////////////////

    function getAccountCollateralValue(address user) public view returns (uint256 totalCollateralValueInUsd) {
        for(uint256 i = 0; i < s_collateralTokens.length; i++) {
            address token = s_collateralTokens[i];
            uint256 amount = s_collateralDeposited[user][token];
            totalCollateralValueInUsd += getUsdValue(token, amount);
        }
        return totalCollateralValueInUsd;
    }

    function getUsdValue(address token, uint256 amount) public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeeds(token));
        (,int256 price,,,) = priceFeed.latestRoundData();

        return ((uint256(price * 1e10) * amount) / 1e18);
    }


//-------------------------Yet to complete Func's ----------------------------------------------------------------

    function depositCollateralAndMintDSC() external {}

    function redeemCollateralForDSC() external {}

    function redeemCollateral() external {}

    

    function burnDSC() external {}

    function liquidate() external {}

    function getHealthFactor() external {}

}
