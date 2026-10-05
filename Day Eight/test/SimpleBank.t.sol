// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import "forge-std/Test.sol";
import "../src/SimpleBank.sol";

contract SimpleBankTest is Test {
    SimpleBank public bank;

    // Dompet simulasi user
    address public alice = address(0x1);
    address public bob = address(0x2);

    function setUp() public {
        bank = new SimpleBank();

        // Memberikan saldo Ether gratis ke dompet simulasi
        vm.deal(alice, 10 ether);
        vm.deal(bob, 5 ether);
    }

    /// @dev TES 1: Menguji alur deposit yang sukses
    function test_DepositSuccess() public {
        vm.prank(alice);
        bank.deposit{value: 2 ether}();

        assertEq(bank.getMyBalance(), 2 ether);
        assertEq(address(bank).balance, 2 ether);
    }

    /// @dev TES 2: Menguji deposit 0 Ether (harus Revert)
    function test_RevertIf_DepositZero() public {
        vm.prank(alice);
        vm.expectRevert(SimpleBank.ZeroAmountNotAllowed.selector);
        bank.deposit{value: 0}();
    }

    /// @dev TES 3: Menguji penarikan saldo yang sukses
    function test_WithdrawSuccess() public {
        vm.startPrank(alice);
        bank.deposit{value: 3 ether}();
        bank.withdraw(1 ether);
        vm.stopPrank();

        vm.prank(alice);
        assertEq(bank.getMyBalance(), 2 ether);
    }

    /// @dev TES 4: Penarikan melebihi saldo (harus Revert)
    function test_RevertIf_WithdrawMoreThanBalance() public {
        vm.startPrank(alice);
        bank.deposit{value: 1 ether}();

        vm.expectRevert();
        bank.withdraw(2 ether);
        vm.stopPrank();
    }
}
