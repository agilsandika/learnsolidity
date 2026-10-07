// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

/// @notice KONTRAK RENTANG REENTRANCY (JANGAN DIGUNAKAN DI PRODUCTION)
contract VulnerableBank {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 bal = balances[msg.sender];
        require(bal > 0, "No balance");

        // CELAH UTAMA: Mengirim Ether SEBELUM mengupdate saldo!
        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");

        // Saldo baru diupdate di sini (terlambat)
        balances[msg.sender] = 0;
    }
}
