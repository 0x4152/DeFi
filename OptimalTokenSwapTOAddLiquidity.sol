// SPDX-License-Identifier: MIT
pragma solidity ^0.7;


//We have 1000 of tokenA, and we want to provide liquidity to the Uniswap Pool of tokens A/B
//We therefore need to swap a certain amount of tokenA for token B, so that it conserves the ratio of the pair.


//We dont want to buy an amount of tokenB based in the present ratio of the pool A/B, because once we execute a swap with 
//our tokens, the ratio will change, and we will be left hanging with some tokens that wont be accepted due to the ratio change.

//The optimal quantity to swap will be based on a prediction of the final ratio we will be left with after the swap

//A = amount of token A in uniswap
//B = amount of token B in uniswap
//f = trading fee 3/1000 in uniswap, 0,3%
//a = amount of token A that I have
//b = amount of token B that I need 
//s = anount of token to swap from A to B


//AMOUNT OF TOKEN A AND TOKEN B           K =      A           B
//AMOUNT OF TOKEN A AND B AFTER SWAP      K = (A + (1-f)s)  (B - b)
//            K = (Previous quantity + (the quantity of tokens we bought - tradingfee))    (Previous quantity - tokens we bought)



// Reserve ratio after swap must be equal to the optimal ratio of tokens we will add liquidity with:

//  reserve ratio after swap    tokens we will add
//      (A + s)/(B - b)     =        (a - s)/b

//if we solve for s we are left with a classic quadratic equation:   (1 - f)s**2 + A(2-f)s -aA = 0

//if we solve the quadratic equation and we substitute f for 3/1000 

//s = (-1997A + sqrt(3988009A**2 + 3988000Aa))/1994

//this will be the formula to maximize liquidity

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/Uniswap.sol";



contract TestUniswapOptimal {
    using SafeMath for uint;

    address private constant FACTORY = 0xfactoryaddress
    address private constant ROUTER = 0xfactoryaddress
    address private constant WETH = 0xfactoryaddress

//import "@uniswap/lib/contracts/libraries/Babylonian.sol"
    function sqrt(uint y) internal pure returns(uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y !=0) {
            z = 1;
        }
        //else z = 0 (default value)
    }

    /*
    s = optimal swap amount
    r = reserve for token a
    a = amount of token tha the user currently has
    f = swap fee percent
    

    we apply the proeviously described formula derived of solving for s
    */
   function getSwapAmount(uint r, uint a) public pure returns (uint) {
    return (sqrt(r.mul(r.mul(3988009) + a.mul(3988000))).sub(r.mul(1997)))/1994;
   }

   function swapAndAddLiquidity( address _tokenA, address _tokenB, _amountA) external {
    IERC20(_tokenA).transferFrom(msg.sender, address(this), _amountA);\

    address pair = IUniswapV2Factory(FACTORY).getPair(_tokenA, _tokenB);
    (uint reserve0, uint reserve1, )= IUniswapV2Pair(pair).getReserves();

    uint swapAmount;

    //we need to know which token is first on the pair contract, we call .token0(), which will return an address, and we compare it to tokenA
    if(IUniswapV2Pair(pair).token0() == _tokenA) {

        swapAmount = getSwapAmount(reserve0, _amountA)
    } else if (IUniswapV2Pair(pair).token1() == _tokenA) {
        swapAmount = getSwapAmount(reserve1, _amountA)
    }
   }

}




