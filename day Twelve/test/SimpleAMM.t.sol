// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import "forge-std/Test.sol";
import "../src/SimpleAMM.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Dummy Token untuk Testing
contract MockToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
}

contract AMMTest is Test {
    SimpleAMM public amm;
    MockToken public tokenA;
    MockToken public tokenB;

    address public alice = address(0x1);

    function setUp() public {
        tokenA = new MockToken("Token A", "TKNA");
        tokenB = new MockToken("Token B", "TKNB");
        amm = new SimpleAMM(address(tokenA), address(tokenB));

        // Transfer token ke Alice & Approve AMM
        tokenA.transfer(alice, 1000 ether);
        tokenB.transfer(alice, 1000 ether);

        vm.startPrank(alice);
        tokenA.approve(address(amm), type(uint256).max);
        tokenB.approve(address(amm), type(uint256).max);
        vm.stopPrank();
    }

    function test_AddLiquidityAndSwap() public {
        vm.startPrank(alice);
        
        // 1. Tambah Likuiditas
        amm.addLiquidity(100 ether, 100 ether);
        assertEq(amm.reserve0(), 100 ether);

        // 2. Swap 10 Token A ke Token B
        uint256 out = amm.swap(address(tokenA), 10 ether);
        assertTrue(out > 0);

        vm.stopPrank();
    }
}
