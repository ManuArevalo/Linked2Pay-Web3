const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("EscrowFactory", function () {
  let factory;
  let client, freelancer, payer, payee, employer;

  beforeEach(async function () {
    [client, freelancer, payer, payee, employer] = await ethers.getSigners();
    const Factory = await ethers.getContractFactory("EscrowFactory");
    factory = await Factory.deploy(); // ✅ FIXED: Removed factory.deployed()
  });

  it("Should create a SubscriptionEscrow contract", async function () {
    await factory.connect(payer).createSubscriptionEscrow(
      payee.address,
      60,
      ethers.parseEther("1"),
      { value: ethers.parseEther("1") }
    );

    const contracts = await factory.getAllSubscriptions();
    expect(contracts.length).to.equal(1);
  });

  it("Should create a PayrollEscrow contract", async function () {
    await factory.connect(employer).createPayrollEscrow();
    const contracts = await factory.getAllPayrolls();
    expect(contracts.length).to.equal(1);
  });

  it("Should create a MilestoneEscrow contract", async function () {
    await factory.connect(client).createMilestoneEscrow(
      freelancer.address,
      2,
      { value: ethers.parseEther("2") }
    );
    const contracts = await factory.getAllMilestones();
    expect(contracts.length).to.equal(1);
  });
});

