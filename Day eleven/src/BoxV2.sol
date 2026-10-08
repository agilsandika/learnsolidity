// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import "./BoxV1.sol";

/// @notice Meng-inherit BoxV1 untuk mencegah Storage Collision
contract BoxV2 is BoxV1 {
    
    // Fitur baru yang ditambahkan di Versi 2
    function increment() public {
        uint256 currentValue = getValue();
        setValue(currentValue + 1);
    }
}
