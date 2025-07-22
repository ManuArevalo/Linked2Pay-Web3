// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title MockIdentityProvider
/// @notice A simple contract to simulate KYC approval checks for testing purposes
contract MockIdentityProvider {
    mapping(address => bool) public kycApproved;

    function setApproval(address user, bool approved) external {
        kycApproved[user] = approved;
    }

    function isKYCApproved(address user) external view returns (bool) {
        return kycApproved[user];
    }
}

