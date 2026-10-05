// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import "forge-std/Script.sol";
import "../src/SimpleBank.sol";

contract DeployBank is Script {
    function run() external returns (SimpleBank) {
        // Membaca Private Key dari environment variable (.env)
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Mulai merekam transaksi yang akan dikirim ke blockchain
        vm.startBroadcast(deployerPrivateKey);

        // Deploy smart contract
        SimpleBank bank = new SimpleBank();

        // Selesai merekam transaksi
        vm.stopBroadcast();

        return bank;
    }
}
