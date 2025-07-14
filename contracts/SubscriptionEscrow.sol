// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SubscriptionEscrow {
    address public payer;
    address public payee;
    uint public interval;
    uint public nextPaymentTime;

    constructor(address _payee, uint _interval) payable {
        require(msg.value > 0, "Must fund escrow");
        payer = msg.sender;
        payee = _payee;
        interval = _interval;
        nextPaymentTime = block.timestamp + interval;
    }

    function pay(uint amount) public {
        require(block.timestamp >= nextPaymentTime, "Too early");
        require(address(this).balance >= amount, "Insufficient balance");
        payable(payee).transfer(amount);
        nextPaymentTime += interval;
    }

    function fund() public payable {}
}