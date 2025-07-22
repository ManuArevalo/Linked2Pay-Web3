// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InvoiceFinancing {
    struct Invoice {
        address seller;
        address buyer;
        uint amount;
        uint dueDate;
        bool paid;
        bool purchased;
    }

    mapping(uint => Invoice) public invoices;
    mapping(address => uint) public reputationalScore;
    uint public invoiceCount;

    event InvoiceSubmitted(uint indexed invoiceId, address indexed seller, uint amount, uint dueDate);
    event InvoicePurchased(uint indexed invoiceId, address indexed financier, uint payout);
    event InvoicePaid(uint indexed invoiceId, address indexed buyer);

    function submitInvoice(address buyer, uint amount, uint dueDate) external {
        invoiceCount++;
        invoices[invoiceCount] = Invoice({
            seller: msg.sender,
            buyer: buyer,
            amount: amount,
            dueDate: dueDate,
            paid: false,
            purchased: false
        });

        emit InvoiceSubmitted(invoiceCount, msg.sender, amount, dueDate);
    }

    function buyInvoice(uint invoiceId, uint payout) external payable {
        Invoice storage invoice = invoices[invoiceId];
        require(!invoice.paid, "Already paid");
        require(!invoice.purchased, "Already purchased");
        require(msg.value == payout, "Incorrect value");

        payable(invoice.seller).transfer(payout);
        invoice.purchased = true;

        emit InvoicePurchased(invoiceId, msg.sender, payout);
    }

    function markPaid(uint invoiceId) external payable {
        Invoice storage invoice = invoices[invoiceId];
        require(msg.sender == invoice.buyer, "Only buyer can pay");
        require(!invoice.paid, "Already paid");
        require(msg.value == invoice.amount, "Incorrect amount");

        invoice.paid = true;
        reputationalScore[msg.sender] += 1;

        emit InvoicePaid(invoiceId, msg.sender);
    }
}
