// SPDX-License-Identifier: MIT
pragma solidity ^0.7;

import "./interfaces/IERC20.sol";
import "./interfaces/Uniswap.sol";

contract TestUniswap {
    address private constant UNISWAP_V2_ROUTER = 0xUniswapV2RouterAddressPasted
    address private constant WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6


    function swap(
        address _tokenIN,
        address _tokenOut,
        uint256 _amountIn,
        uint256 _amountOutMin,
        address _to
    ) external {
        //we transfer the tokens, to this contract, and we approve the UNISWAP_V2_Router with the tokens we recieved
        IERC20(_tokenIN).transferFrom(msg.sender, address(this), _amountIn);
        IERC20(_tokenIN).approve(UNISWAP_V2_ROUTER,_amountIn);

        address[] memory path;
        path = new address[](3);
        path[0] = _tokenIn;
        path[1] = WETH;
        path[2] = _tokenOut;

        IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForTokens(_amountIn, _amountOutMin, path, _to, block.timestamp);

    }
}