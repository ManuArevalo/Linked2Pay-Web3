// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IIdentityProvider {
    function isKYCApproved(address user) external view returns (bool);
}

contract ComplianceGate {
    address public identityProvider;

    constructor(address _identityProvider) {
        identityProvider = _identityProvider;
    }

    function verifyCompliance(address user) external view returns (bool) {
        return IIdentityProvider(identityProvider).isKYCApproved(user);
    }
}

