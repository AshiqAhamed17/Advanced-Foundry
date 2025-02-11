//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./interfaces/IRebaseToken.sol";

contract Vault {

    ////////////////
    /// Errors ////
    ///////////////

    error Vault__RedeemFailed();

    //////////////////////
    // State Variables //
    /////////////////////
    IRebaseToken private immutable i_rebaseToken;

    //////////////////////
    /////// Events ///////
    //////////////////////
    event Deposit(address indexed user, uint256 amount);
    event Redeem(address indexed user, uint256 amount);
    
    /////////////////////
    /// Constructor  ///
    ////////////////////
    constructor(IRebaseToken _rebaseToken) {
        i_rebaseToken = _rebaseToken;
    }
    
    /////////////////////
    //// Functions  ////
    ////////////////////
    
    receive() external payable {}

    /**
     * @notice Allows users to deposit ETH into the vault and mint rebase tokens in return.
     */
    function deposit() external payable {
        uint256 amount = msg.value;
        i_rebaseToken.mint(msg.sender, amount);
        emit Deposit(msg.sender, amount);
    }

    /**
     * @dev redeems rebase token for the underlying asset
     * @param _amount the amount being redeemed
     */
    function redeem(uint256 _amount) external {
        // Burn the tokens from the user
        i_rebaseToken.burn(msg.sender, _amount);

        // Send the user ETH
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        if(!success) {
            revert Vault__RedeemFailed();
        }
        emit Redeem(msg.sender, _amount);
    }

    function getRebaseTokenAddress() external view returns (address) {
        return address(i_rebaseToken);
    }
}