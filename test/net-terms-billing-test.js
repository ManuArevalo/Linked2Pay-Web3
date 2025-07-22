const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NetTermsBilling", function () {
  let contract;
  let provider, client;

  beforeEach(async function () {
    [provider, client] = await ethers.getSigners();

    const NetTermsBillingFactory = await ethers.getContractFactory("NetTermsBilling");
    contract = await NetTermsBillingFactory.deploy();
    await contract.deployed();
  });

  it("Should allow creation of terms and payment within deadline", async function () {
    const amount = ethers.utils.parseEther("2");
    const dueDate = Math.floor(Date.now() / 1000) + 5 * 86400;

    await contract.connect(provider).initiateTerms(client.address, amount, dueDate);

    const term = await contract.terms(client.address);
    expect(term.amount).to.equal(amount);
    expect(term.dueDate).to.equal(dueDate);
    expect(term.paid).to.equal(false);

    await expect(() =>
      contract.connect(client).payBeforeDue({ value: amount })
    ).to.changeEtherBalance(provider, amount);

    const updatedTerm = await contract.terms(client.address);
    expect(updatedTerm.paid).to.equal(true);
  });

  it("Should apply penalty after deadline", async function () {
    const amount = ethers.utils.parseEther("1");
    const dueDate = Math.floor(Date.now() / 1000) - 3600;

    await contract.connect(provider).initiateTerms(client.address, amount, dueDate);

    await expect(() =>
      contract.connect(client).penaltyAfterDue({ value: amount })
    ).to.changeEtherBalance(provider, amount);

    const updatedTerm = await contract.terms(client.address);
    expect(updatedTerm.paid).to.equal(true);
  });
});
