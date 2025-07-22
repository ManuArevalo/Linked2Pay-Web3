const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ComplianceGate", function () {
  let complianceGate, identityProviderMock;
  let owner, user;

  beforeEach(async function () {
    [owner, user] = await ethers.getSigners();

    const IdentityProviderFactory = await ethers.getContractFactory("MockIdentityProvider");
    identityProviderMock = await IdentityProviderFactory.deploy();
    await identityProviderMock.deployed();

    const ComplianceGateFactory = await ethers.getContractFactory("ComplianceGate");
    complianceGate = await ComplianceGateFactory.deploy(identityProviderMock.address);
    await complianceGate.deployed();
  });

  it("Should verify compliant user", async function () {
    await identityProviderMock.setApproval(user.address, true);
    const result = await complianceGate.verifyCompliance(user.address);
    expect(result).to.equal(true);
  });

  it("Should reject non-compliant user", async function () {
    await identityProviderMock.setApproval(user.address, false);
    const result = await complianceGate.verifyCompliance(user.address);
    expect(result).to.equal(false);
  });
});
