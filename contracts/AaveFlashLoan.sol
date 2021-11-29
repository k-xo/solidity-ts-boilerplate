// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import './interfaces/FlashLoanReceiverBase.sol';

contract AaveFlashLoan is FlashLoanReceiverBase {
    using SafeMath for uint256;

    event Log(string message, uint256 value);

    constructor(ILendingPoolAddressesProvider _addressProvider) FlashLoanReceiverBase(_addressProvider) {}

    function flashLoan(address asset, uint256 amount) external {
        address receiver = address(this);

        //setting an array of tokens that we want to borrow
        address[] memory assets = new address[](1);
        assets[0] = asset;

        //set the amount of the token that we want to borrow
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = amount;

        // 0 = no debt, 1 = stable, 2 = variable
        uint256[] memory modes = new uint256[](1);
        modes[0] = 0;

        //taking the flash loan on behalf of 'this' address
        address onBehalfOf = address(this);

        bytes memory params = '';
        uint16 referralCode = 0;

        LENDING_POOL.flashLoan(receiver, assets, amounts, modes, onBehalfOf, params, referralCode);
    }

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // add logic here, such as arbitrage etc.

        for (uint256 i = 0; i < assets.length; i++) {
            emit Log('Amount Borrowed', amounts[i]);
            emit Log('Fee', premiums[i]);

            uint256 amountToPayback = amounts[i].add(premiums[i]);
            IERC20(assets[i]).approve(address(LENDING_POOL), amountToPayback);
        }

        return true;
    }
}
