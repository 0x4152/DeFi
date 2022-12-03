// SPDX-License-Identifier: MIT
pragma solidity ^0.7;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/aave/FlashLoanReceiverBase.sol";



//similar to the chainlink VRF, we will create a function that requests the flashloan, and a second function that executes with the tokens
//from the flashloan. The second function is external override 
contract FlashLoan is FlashLoanRecieverBase {
    using SafeMath for uint;

    constructor(
        ILendingPoolAddressesProvider _addressProvider
    ) public FlashLoanRecieverBase(_addressProvider) {

        function testFlashLoan(address asset, uint amount) external {
            uint bal = IERC20(asset).balanceOf(address(this));
            //we will have to repay more than what we borrowed, so we chech that balance on this contract is higher that amount
            require(bal> amount, "bal <= amount");

            address receiver = address(this);
            address[] memory assets = new address[](1);
            assets[0] = asset;
            uint[] memory amounts = new uint[](1);
            amounts[0] = amount ; 
            uint[] memory modes = new uint[](1);
            modes[0] = 0;
            address onBehalfOf = address(this);
            bytes memory params = ""; 
            uint16 referralCode = 0;

            //Lending pool is a contract specified inside FlashLoanReceiverBase
            LENDING_POOL.flashLoan(
                receiver, //address of the contract that is going to recieve the borrowed funds
                assets, //array of tokens we want to borrow
                amounts,
                modes, //modes 0 = no debt, 1 = stable, 2= variable
                onBehalfOf, //the address that will be recieving the debt in case the mode is 1 or 2
                params, //extra data to pass abi.encode to executeOperations
                referralCode
            );

        }

        function executeOperation(addresss[] calldata assets, uint[] calldata amoutns, uint[] calldata premiums, address initiator, bytes calldata params) external override returns (bool) {
            // custom code, whatever we want to do with the flash loan (arbitrage, liquidation, etc)
            // abi.decode(params) to decode the params

            for (uint i = 0; i < assets.length; i++) {
                emit Log("borrowed", amounts[i]);
                emit Log("Fee", premiums[i]);

                uint amountOwning = amounts[i].add(premiums[i]);
                IERC20(assets[i]).approve(address(LENDING_POOL), amountOwning);
            }
            //repay aave
            
            
            
            return true; 
        }
    }
}
