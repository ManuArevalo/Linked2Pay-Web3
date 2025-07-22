const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TokenPaymentAuthorization", function () {
  let contract;
  let token;
  let payer, merchant, other;
  let amount;

  beforeEach(async function () {
    [payer, merchant, other] = await ethers.getSigners();
    amount = ethers.utils.parseEther("10");

    // Deploy MockERC20 token
    const MockERC20 = await ethers.getContractFactory("MockERC20");
    token = await MockERC20.deploy("Mock Token", "MTK", payer.address, ethers.utils.parseEther("1000"));
    await token.deployed();

    // Deploy TokenPaymentAuthorization contract
    const TokenPaymentAuthorization = await ethers.getContractFactory("TokenPaymentAuthorization");
    contract = await TokenPaymentAuthorization.deploy();
    await contract.deployed();

    // Approve the contract to spend payer's tokens
    await token.connect(payer).approve(contract.address, amount);
  });

  it("Should create and execute an authorization", async function () {
    // Generate hashed message
    const hash = ethers.utils.solidityKeccak256(["address", "uint256"], [merchant.address, amount]);
    const signature = await payer.signMessage(ethers.utils.arrayify(hash));

    // Authorize payment
    await expect(() =>
      contract.connect(merchant).authorize(token.address, payer.address, amount, signature)
    ).to.changeTokenBalances(token, [payer, merchant], [amount.mul(-1), amount]);

    const auth = await contract.getAuthorization(payer.address, merchant.address);
    expect(auth.amount).to.equal(amount);
  });

  it("Should reject invalid signature", async function () {
    const hash = ethers.utils.solidityKeccak256(["address", "uint256"], [merchant.address, amount]);
    const fakeSignature = await other.signMessage(ethers.utils.arrayify(hash));

    await expect(
      contract.connect(merchant).authorize(token.address, payer.address, amount, fakeSignature)
    ).to.be.revertedWith("Invalid signature");
  });
});
