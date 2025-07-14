const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MilestoneEscrow", function () {
  it("Should release milestone payments", async function () {
    const [client, freelancer] = await ethers.getSigners();
    const Escrow = await ethers.getContractFactory("MilestoneEscrow");
    const escrow = await Escrow.deploy(freelancer.address, 2, { value: ethers.parseEther("2") });

    await escrow.releasePayment();
    let balance = await ethers.provider.getBalance(escrow.getAddress());
    expect(balance).to.equal(ethers.parseEther("1"));

    await escrow.releasePayment();
    balance = await ethers.provider.getBalance(escrow.getAddress());
    expect(balance).to.equal(ethers.parseEther("0"));
  });
});
