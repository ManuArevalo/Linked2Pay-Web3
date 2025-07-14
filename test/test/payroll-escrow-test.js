const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PayrollEscrow", function () {
  it("Should add employee and pay salary", async function () {
    const [employer, employee] = await ethers.getSigners();
    const Escrow = await ethers.getContractFactory("PayrollEscrow");
    const escrow = await Escrow.deploy();

    await escrow.addEmployee(employee.address, ethers.parseEther("1"));
    await escrow.fund({ value: ethers.parseEther("1") });

    await escrow.distributePayroll();
    const balance = await ethers.provider.getBalance(escrow.getAddress());
    expect(balance).to.equal(ethers.parseEther("0"));
  });
});
