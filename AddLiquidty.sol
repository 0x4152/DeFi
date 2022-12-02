// SPDX-License-Identifier: MIT
pragma solidity ^0.7;

import "./interfaces/IERC20.sol";
import "./interfaces/Uniswap.sol";

//The structure we use is:
//To actually addLiquidity and remove liquidity, the ROUTER contract needs to be approved 
//therefore we transfer the tokens to this contract and approve the ROUTER to manipulate them.
//It is then when we call the functions on the router contract

//To remove liquidity:
//Factory will give us the address of the ERC20 that represents the liquidityToken for the pool where we added liquidity
//We approve the ROUTER coontract to manipulate our liquidty tokens to removeLiquidity
contract AddLiquidity{
    address private constant FACTORY = ;
    address private constant ROUTER = ;
    address private constant WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6 ; 

    event Log(string message, uint256 val);

    function addLiquidity(
        address _tokenA,
        address _tokenB,
        uint256 _amountA,
        uint256 _amountB
    ) external {
        IERC20(_tokenA).transferFrom(msg.sender, address(this), _amountA);
        IERC20(_tokenB).transferFrom(msg.sender, address(this), _amountB);

        IERC20(_tokenA).approve(ROUTER, _amountA);
        IERC20(_tokenB).approve(ROUTER, _amountB);

        //the function will return the actual amount of tokens that were set to add liquidity, with the total liquidity tokens
        (uint256 _amountA, uint256 _amountB, uint256 liquidity) =  IUniswapV2Router(ROUTER).addLiquidity(
            _tokenA,
            _tokenB,
            _amountA,
            _amountB.
            1,
            1,
            address(this),
            block.timestamp
        );

        emit Log("amountA", amountA);
        emit Log("amoungB", amountB);
        emit Log("liquidity", liquidity);

    }

    function removeLiquidity(address _tokenA, address _tokenB ) external {
        //get the address of the actual liquidity pool where we are gonna call removeLiquidity
        address pair = IUniswapV2Factory(FACTORY).getPair(_tokenA, _tokenB);

        //the contract has a mapping to store how much liquidity tokens for that pair each address has
        //we call that to get the total liquidity tokens we own, to later remove that quantity
        uint256 liquidity = IERC20(pair).balanceOf(address(this));


        //we now approve the ROUTER contract so that it can manipulate the tokens
        IERC20(pair).approve(ROUTER, liquidity);

        IUniswapV2Router(ROUTER).removeLiquidity(
            _tokenA,
            _tokenB,
            liquidity,
            1,
            1,
            address(this),
            block.timestamp
        )




    }




}