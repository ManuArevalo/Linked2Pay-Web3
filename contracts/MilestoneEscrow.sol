// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MilestoneEscrow {
    address public client;
    address public freelancer;
    uint public totalAmount;
    uint public milestoneCount;
    uint public currentMilestone;

    constructor(address _freelancer, uint _milestoneCount) payable {
        require(msg.value > 0, "Funding required");
        client = msg.sender;
        freelancer = _freelancer;
        totalAmount = msg.value;
        milestoneCount = _milestoneCount;
        currentMilestone = 0;
    }

    function releasePayment() public {
        require(msg.sender == client, "Only client can release");
        require(currentMilestone < milestoneCount, "All milestones paid");
        uint payment = totalAmount / milestoneCount;
        payable(freelancer).transfer(payment);
        currentMilestone++;
    }

    function refund() public {
        require(msg.sender == client, "Only client");
        require(currentMilestone == 0, "Cannot refund after payment");
        payable(client).transfer(address(this).balance);
    }
}
