// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract TokenPaymentAuthorization {
    address public admin;

    struct Authorization {
        address payer;
        address payee;
        uint256 amount;
        uint256 expiration;
        bool executed;
    }

    mapping(bytes32 => Authorization) public authorizations;

    event AuthorizationCreated(bytes32 indexed authId, address payer, address payee, uint256 amount, uint256 expiration);
    event AuthorizationExecuted(bytes32 indexed authId);

    constructor() {
        admin = msg.sender;
    }

    function createAuthorization(
        address payer,
        address payee,
        uint256 amount,
        uint256 expiration
    ) external returns (bytes32) {
        require(msg.sender == payer || msg.sender == admin, "Not authorized to create");
        bytes32 authId = keccak256(abi.encodePacked(payer, payee, amount, expiration, block.timestamp));

        authorizations[authId] = Authorization({
            payer: payer,
            payee: payee,
            amount: amount,
            expiration: expiration,
            executed: false
        });

        emit AuthorizationCreated(authId, payer, payee, amount, expiration);
        return authId;
    }

    function executeAuthorization(bytes32 authId, address token) external {
        Authorization storage auth = authorizations[authId];
        require(block.timestamp <= auth.expiration, "Authorization expired");
        require(!auth.executed, "Already executed");

        auth.executed = true;
        require(IERC20(token).transferFrom(auth.payer, auth.payee, auth.amount), "Transfer failed");

        emit AuthorizationExecuted(authId);
    }
}
