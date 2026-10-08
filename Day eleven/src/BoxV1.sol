// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract BoxV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 private value;
    
    constructor() {
        _disableInitializers();
    }

    // Menggantikan fungsi constructor bawaan
    function initialize(uint256 _initialValue) public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        value = _initialValue;
    }

    function getValue() public view returns (uint256) {
        return value;
    }

    function setValue(uint256 _newValue) public {
        value = _newValue;
    }

    // Fungsi wajib UUPS untuk membatasi siapa yang boleh upgrade
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}

