// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

contract SecureBank {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        // 1. CHECKS (Pemeriksaan)
        uint256 bal = balances[msg.sender];
        require(bal > 0, "No balance");

        // 2. EFFECTS (Update State Terlebih Dahulu!)
        balances[msg.sender] = 0;

        // 3. INTERACTIONS (Pengiriman Ether Dilakukan Terakhir)
        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");
    }
}
