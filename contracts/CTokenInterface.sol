// SPDX-License-Identifier: MIT
pragma solidity 0.7.3;

interface CTokenInterface {
    function mint(uint amount) external returns(uint);
    function redeem(address redeemToken) external returns(uint);
    function redeemUnderlying(uint amount) external returns(uint);
    function borrow(uint borrowAmount) external returns(uint);
    function repayBorrow(uint repayAmount) external returns(uint);
    function underlying() external view returns(address); 
}