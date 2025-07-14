const { ethers } = require("hardhat");
const { parseEther } = require("ethers");

describe("SubscriptionEscrow", function () {
  it("Should trigger payment after interval", async function () {
    const [payer, payee] = await ethers.getSigners();
    const Escrow = await ethers.getContractFactory("SubscriptionEscrow");
    // Only pass payee.address and interval, and use { value: ... } for funding
    const escrow = await Escrow.connect(payer).deploy(
      payee.address,
      60, // interval
      { value: parseEther("1") } // initial funding
    );
    // ...rest of your test...
  });
});