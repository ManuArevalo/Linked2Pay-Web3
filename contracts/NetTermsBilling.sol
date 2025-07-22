// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NetTermsBilling {
    struct Term {
        uint amount;
        uint dueDate;
        bool paid;
    }

    mapping(address => Term) public terms;

    function initiateTerms(address client, uint amount, uint dueDate) external {
        require(dueDate > block.timestamp, "Due date must be in future");
        terms[client] = Term(amount, dueDate, false);
    }

    function payBeforeDue() external payable {
        Term storage term = terms[msg.sender];
        require(block.timestamp <= term.dueDate, "Past due date");
        require(!term.paid, "Already paid");
        require(msg.value == term.amount, "Incorrect amount");
        term.paid = true;
        payable(tx.origin).transfer(msg.value);
    }

    function penaltyAfterDue() external payable {
        Term storage term = terms[msg.sender];
        require(block.timestamp > term.dueDate, "Still within due");
        require(!term.paid, "Already paid");
        require(msg.value == term.amount, "Incorrect amount");
        term.paid = true;
        payable(tx.origin).transfer(msg.value);
    }
}

