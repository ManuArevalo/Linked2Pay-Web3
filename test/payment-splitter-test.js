const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PaymentSplitter", function () {
  let splitter;
  let owner, acc1, acc2;

  beforeEach(async function () {
    [owner, acc1, acc2] = await ethers.getSigners();
    const PaymentSplitter = await ethers.getContractFactory("PaymentSplitter");
    splitter = await PaymentSplitter.deploy();

    await splitter.setSplit(
      [acc1.address, acc2.address],
      [6000, 4000] // 60%, 40%
    );

    // Send 1 ETH to the contract from the owner
    await owner.sendTransaction({
      to: splitter.address,
      value: ethers.utils.parseEther("1")
    });
  });

  it("Should distribute payments correctly", async function () {
    await expect(() =>
      splitter.connect(owner).distribute()
    ).to.changeEtherBalances(
      [acc1, acc2],
      [
        ethers.utils.parseEther("0.6"),
        ethers.utils.parseEther("0.4")
      ]
    );
  });

  it("Should revert if total share is not 100%", async function () {
    await expect(
      splitter.setSplit(
        [acc1.address, acc2.address],
        [5000, 3000] // Only 8000 = 80%
      )
    ).to.be.revertedWith("Invalid BPS total");
  });
});

