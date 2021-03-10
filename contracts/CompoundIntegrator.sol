// SPDX-License-Identifier: MIT
pragma solidity 0.7.3;

import "./IERC20.sol";
import "./PriceOracleInterface.sol";
import "./CTokenInterface.sol";
import "./ControllerInterface.sol";

contract CompoundIntegrator {

    ControllerInterface public controller;
    PriceOracleInterface public priceOracle;

    constructor(address _controller, address _oracle) {
        controller = ControllerInterface(_controller);
        priceOracle = PriceOracleInterface(_oracle);
    }

    function supply(address _cTokenAddress, uint underlyingAmount) external {
        CTokenInterface ctoken = CTokenInterface(_cTokenAddress);
        address underlyingAddress = ctoken.underlying();
        IERC20(underlyingAddress).approve( underlyingAddress, underlyingAmount);
        uint result = ctoken.mint(underlyingAmount);
        require(result == 0, "cToken mint failed");
    }

    function redeem(address cToken) external {
        CTokenInterface ctoken = CTokenInterface(cToken);
        uint result = ctoken.redeem(cToken);
        require(result == 0, "cToken redeem failed");
    }

    function enterMarket(address cTokenAddress) external{
        address[] memory markets = new address[](1);
        markets[0] = cTokenAddress;
        uint[] memory results = controller.enterMarkets(markets);
        require(results[0] == 0, "enter market failed");
    }

    function borrow(address cTokenAddress, uint amount) external{
        CTokenInterface ctoken = CTokenInterface(cTokenAddress);
        address underlyingAddress = ctoken.underlying();
        uint result = ctoken.borrow(amount);
        require(result == 0, "borrowing failed");
    }

    function repayBorrow(address cTokenAddress, uint underlyingAmount) external {
        CTokenInterface ctoken = CTokenInterface(cTokenAddress);
        address underlyingAddress = ctoken.underlying();
        IERC20(underlyingAddress).approve(cTokenAddress, underlyingAmount);
        uint results = ctoken.repayBorrow(underlyingAmount);
        require(results == 0, "repayment failed");
    }

    function getMaxBorrow(address cTokenAddress) external view returns(uint) {
        (uint result, uint liquidity, uint shortfall) = controller.getAccountLiquidity(address(this));
        require(result == 0, "get account liquidity failed");
        require(shortfall == 0, "account underwater");
        require(liquidity > 0, "account does not have collateral");
        uint underlyingPrice = priceOracle.getUnderlyingPrice(cTokenAddress);
        return liquidity/underlyingPrice;
    }  
}