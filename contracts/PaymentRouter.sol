// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentRouter {
    address public admin;

    // Supported values: "ACH", "FedNow", "USDC", etc.
    mapping(address => string) public preferredRail;

    // Event for audit logging
    event PreferredRailSet(address indexed user, string rail);
    event RoutedPayment(address indexed user, string rail);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @notice Set a user's preferred payment rail (e.g., USDC, FedNow)
     */
    function setPreferredRail(address user, string memory rail) external onlyAdmin {
        preferredRail[user] = rail;
        emit PreferredRailSet(user, rail);
    }

    /**
     * @notice View function to get a user's preferred rail
     */
    function getPreferredRail(address user) external view returns (string memory) {
        return preferredRail[user];
    }

    /**
     * @notice Route a payment based on the stored preferred rail
     * (In production, this would be off-chain logic calling back into on-chain hooks.)
     */
    function routePayment(address user) external view returns (string memory) {
        string memory rail = preferredRail[user];
        require(bytes(rail).length > 0, "No preferred rail set");
        return rail;
    }

    /**
     * @dev Example placeholder for future integration with compliance modules
     */
    function isCompliant(address user) public pure returns (bool) {
        // Placeholder: Integrate with Verite, zk-KYC, TRM Labs oracle, etc.
        return true;
    }
}
