// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentSplitter {
    address public owner;
    address[] public recipients;
    uint[] public basisPoints; // out of 10,000

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function setSplit(address[] memory _recipients, uint[] memory _bps) external onlyOwner {
        require(_recipients.length == _bps.length, "Length mismatch");

        uint totalBps = 0;
        for (uint i = 0; i < _bps.length; i++) {
            totalBps += _bps[i];
        }

        require(totalBps == 10000, "Invalid BPS total");

        recipients = _recipients;
        basisPoints = _bps;
    }

    function distribute() external {
        uint balance = address(this).balance;
        require(balance > 0, "No ETH to distribute");

        for (uint i = 0; i < recipients.length; i++) {
            uint share = (balance * basisPoints[i]) / 10000;
            (bool success, ) = recipients[i].call{value: share}("");
            require(success, "Transfer failed");
        }
    }

    function getRecipients() external view returns (address[] memory) {
        return recipients;
    }

    function getBasisPoints() external view returns (uint[] memory) {
        return basisPoints;
    }
}
