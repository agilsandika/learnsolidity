// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title Simple Constant Product AMM (x * y = k)
contract SimpleAMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint256 public reserve0;
    uint256 public reserve1;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address _to, uint256 _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function _burn(address _from, uint256 _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    /// @notice Menambah Likuiditas ke dalam Pool
    function addLiquidity(uint256 _amount0, uint256 _amount1) external returns (uint256 shares) {
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);

        if (totalSupply == 0) {
            shares = _amount0 + _amount1; // Perhitungan awal shares sederhana
        } else {
            uint256 share0 = (_amount0 * totalSupply) / reserve0;
            uint256 share1 = (_amount1 * totalSupply) / reserve1;
            shares = share0 < share1 ? share0 : share1;
        }

        require(shares > 0, "shares = 0");
        _mint(msg.sender, shares);

        reserve0 = token0.balanceOf(address(this));
        reserve1 = token1.balanceOf(address(this));
    }

    /// @notice Melakukan Penukaran Token (Swap)
    function swap(address _tokenIn, uint256 _amountIn) external returns (uint256 amountOut) {
        require(_tokenIn == address(token0) || _tokenIn == address(token1), "Invalid token");
        require(_amountIn > 0, "Amount in must be > 0");

        bool isToken0 = _tokenIn == address(token0);
        (IERC20 tokenIn, IERC20 tokenOut, uint256 resIn, uint256 resOut) = isToken0
            ? (token0, token1, reserve0, reserve1)
            : (token1, token0, reserve1, reserve0);

        tokenIn.transferFrom(msg.sender, address(this), _amountIn);

        // Rumus Swap dx -> dy dengan fee 0.3%
        uint256 amountInWithFee = (_amountIn * 997) / 1000;
        amountOut = (resOut * amountInWithFee) / (resIn + amountInWithFee);

        tokenOut.transfer(msg.sender, amountOut);

        reserve0 = token0.balanceOf(address(this));
        reserve1 = token1.balanceOf(address(this));
    }
}
