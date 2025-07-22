const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("InvoiceFinancing", function () {
  let invoiceFinancing;
  let seller, buyer, financier;

  beforeEach(async function () {
    [seller, buyer, financier] = await ethers.getSigners();

    const InvoiceFinancingFactory = await ethers.getContractFactory("InvoiceFinancing");
    invoiceFinancing = await InvoiceFinancingFactory.deploy();
    await invoiceFinancing.deployed();
  });

  it("Should submit and purchase an invoice", async function () {
    const amount = await ethers.utils.parseEther("5");
    const payout = await ethers.utils.parseEther("4");
    const dueDate = Math.floor(Date.now() / 1000) + 7 * 86400;

    await invoiceFinancing.connect(seller).submitInvoice(buyer.address, amount, dueDate);

    const invoice = await invoiceFinancing.invoices(1);
    expect(invoice.amount).to.equal(amount);
    expect(invoice.buyer).to.equal(buyer.address);

    await expect(() =>
      invoiceFinancing.connect(financier).buyInvoice(1, payout, { value: payout })
    ).to.changeEtherBalances([financier, seller], [payout.mul(-1), payout]);

    const updated = await invoiceFinancing.invoices(1);
    expect(updated.purchased).to.equal(true);
  });

  it("Should allow buyer to mark invoice as paid", async function () {
    const amount = await ethers.utils.parseEther("6");
    const dueDate = Math.floor(Date.now() / 1000) + 3 * 86400;

    await invoiceFinancing.connect(seller).submitInvoice(buyer.address, amount, dueDate);

    await expect(() =>
      invoiceFinancing.connect(buyer).markPaid(1, { value: amount })
    ).to.changeEtherBalance(invoiceFinancing, amount);

    const invoice = await invoiceFinancing.invoices(1);
    expect(invoice.paid).to.equal(true);
  });
});

