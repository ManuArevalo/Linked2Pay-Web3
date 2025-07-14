// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SubscriptionEscrow.sol";
import "./PayrollEscrow.sol";
import "./MilestoneEscrow.sol";

contract EscrowFactory {
    address[] public subscriptionContracts;
    address[] public payrollContracts;
    address[] public milestoneContracts;

    event SubscriptionCreated(address indexed contractAddress, address indexed payer);
    event PayrollCreated(address indexed contractAddress, address indexed employer);
    event MilestoneCreated(address indexed contractAddress, address indexed client);

    // Adjusted: Only pass _payee and _interval to SubscriptionEscrow
    function createSubscriptionEscrow(address _payee, uint _interval, uint _amount) public payable {
        require(msg.value >= _amount, "Insufficient initial funding");
        SubscriptionEscrow escrow = (new SubscriptionEscrow){value: msg.value}(_payee, _interval);
        subscriptionContracts.push(address(escrow));
        emit SubscriptionCreated(address(escrow), msg.sender);
    }

    function createPayrollEscrow() public {
        PayrollEscrow payroll = new PayrollEscrow();
        payrollContracts.push(address(payroll));
        emit PayrollCreated(address(payroll), msg.sender);
    }

    function createMilestoneEscrow(address _freelancer, uint _milestoneCount) public payable {
        require(msg.value > 0, "Funding required");
        MilestoneEscrow milestone = (new MilestoneEscrow){value: msg.value}(_freelancer, _milestoneCount);
        milestoneContracts.push(address(milestone));
        emit MilestoneCreated(address(milestone), msg.sender);
    }

    function getAllSubscriptions() public view returns (address[] memory) {
        return subscriptionContracts;
    }

    function getAllPayrolls() public view returns (address[] memory) {
        return payrollContracts;
    }

    function getAllMilestones() public view returns (address[] memory) {
        return milestoneContracts;
    }
}