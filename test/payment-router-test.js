const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PaymentRouter", function () {
  let contract;
  let admin, user;

  beforeEach(async function () {
    [admin, user] = await ethers.getSigners();

    const PaymentRouter = await ethers.getContractFactory("PaymentRouter");
    contract = await PaymentRouter.deploy();
    await contract.deployed();
  });

  it("Should allow admin to set preferred rail", async function () {
    await contract.connect(admin).setPreferredRail(user.address, "USDC");
    const preferred = await contract.preferredRail(user.address);
    expect(preferred).to.equal("USDC");
  });

  it("Should prevent non-admin from setting rail", async function () {
    await expect(
      contract.connect(user).setPreferredRail(user.address, "ACH")
    ).to.be.revertedWith("Only admin");
  });
});
