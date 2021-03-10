// SPDX-License-Identifier: MIT
pragma solidity 0.7.3;

interface ControllerInterface {
    function enterMarkets(address[] calldata cTokens) external returns(uint[] memory);
    function getAccountLiquidity(address) external view returns(uint, uint, uint); 
}