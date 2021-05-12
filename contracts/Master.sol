// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface IERC20 {
  function totalSupply() external returns(uint256);
  function balanceOf(address) external returns(uint256);
}

interface IRouter {
  function addLiquidity(
    address tokenA,
    address tokenB,
    uint256 amountADesired,
    uint256 amountBDesired,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline
  )
    external
    returns (
        uint256 amountA,
        uint256 amountB,
        uint256 liquidity
    );
}

contract Master {
  address public gift_address = 0xBE0eB53F46cd790Cd13851d5EFf43D12404d33E8;
  uint256 public gift_ratio = 50; // 50%

  constructor() public {}
  function init_liquidity(address horse, address payable router, address currency) external payable {
    uint256 total = IERC20(horse).balanceOf(address(this));
    uint256 gift_amount = total * gift_ratio / 100;
    uint256 liquidity_amount = total - gift_amount;
    safeTransfer(horse, gift_address, gift_amount);
    safeApprove(horse, router, liquidity_amount);

    uint256 currency_amount = IERC20(currency).balanceOf(address(this));
    safeApprove(currency, router, currency_amount);
    IRouter(router).addLiquidity(
        currency,
        horse,
        currency_amount,
        liquidity_amount,
        currency_amount,
        liquidity_amount,
        address(this),
        block.timestamp + 1
      );
  }

  function safeTransfer(address token, address to, uint value) internal {
    (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
    require(success && (data.length == 0 || abi.decode(data, (bool))), "Master: TRANSFER_FAILED");
  }

  function safeApprove(address token, address to, uint value) internal {
    (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
    require(success && (data.length == 0 || abi.decode(data, (bool))), "Master: APPROVE_FAILED");
  }
}
