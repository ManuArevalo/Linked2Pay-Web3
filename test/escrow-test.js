const { ethers } = require("hardhat");
const { parseEther } = require("ethers");

describe("SubscriptionEscrow", function () {
  it("Should deploy and fund the contract", async function () {
    const [payer, payee] = await ethers.getSigners();
    const Escrow = await ethers.getContractFactory("SubscriptionEscrow");
    const escrow = await Escrow.connect(payer).deploy(
      payee.address,
      60,
      { value: parseEther("1") }
    );

    console.log("Escrow deployed at:", escrow.target); // In ethers v6, use .target for address
  });
});
