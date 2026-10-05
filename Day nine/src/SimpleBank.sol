// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

/// @title Simple Bank Smart Contract
/// @notice Smart contract bank sederhana untuk pengujian Day 8
contract SimpleBank {
    // Custom Errors
    error ZeroAmountNotAllowed();
    error InsufficientBalance(uint256 currentBalance, uint256 requestedAmount);

    // Event Logs
    event LogDeposit(address indexed user, uint256 amount);
    event LogWithdrawal(address indexed user, uint256 amount);

    // State Variable
    mapping(address => uint256) private balances;

    /// @notice Menyetorkan Ether ke bank
    function deposit() public payable {
        if (msg.value == 0) {
            revert ZeroAmountNotAllowed();
        }

        balances[msg.sender] += msg.value;
        emit LogDeposit(msg.sender, msg.value);
    }

    /// @notice Penarikan Ether dari bank
    function withdraw(uint256 _amount) public {
        if (_amount == 0) {
            revert ZeroAmountNotAllowed();
        }
        if (balances[msg.sender] < _amount) {
            revert InsufficientBalance(balances[msg.sender], _amount);
        }

        balances[msg.sender] -= _amount;
        emit LogWithdrawal(msg.sender, _amount);

        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Transfer failed");
    }

    /// @notice Mengecek saldo wallet pemanggil
    function getMyBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
