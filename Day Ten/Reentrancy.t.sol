// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import "forge-std/Test.sol";
import "../src/VulnerableBank.sol";
import "../src/Attacker.sol";

contract ReentrancyTest is Test {
    VulnerableBank public bank;
    Attacker public attacker;

    address public victim = address(0x1);

    function setUp() public {
        bank = new VulnerableBank();
        attacker = new Attacker(address(bank));

        // Korban deposit 10 Ether ke bank
        vm.deal(victim, 10 ether);
        vm.prank(victim);
        bank.deposit{value: 10 ether}();

        // Modal peretas 1 Ether
        vm.deal(address(attacker), 1 ether);
    }

    function test_ReentrancyAttack() public {
        // Peretas mulai menyerang
        attacker.attack();

        // Seluruh Ether di bank (11 Ether) berhasil dikuras peretas
        assertEq(address(bank).balance, 0);
        assertEq(address(attacker).balance, 11 ether);
    }
}
