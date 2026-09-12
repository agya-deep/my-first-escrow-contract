// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Escrow {
    address public seller;
    address public buyer;
    uint256 public amount;
    bool public deposited;
    bool public released;
    uint256 public deadline;
    bool public refunded;

    constructor(address _seller, address _buyer, uint256 _deadline) {
        require(_seller != address(0), "Seller address cannot be zero");
        require(_buyer != address(0), "Buyer address cannot be zero");
        seller = _seller;
        buyer = _buyer;
        deadline = block.timestamp + _deadline;
    }
    function deposit() external payable {
        require(!deposited, "Funds are already deposited");
        require(msg.sender == buyer, "Only buyer can deposit");
        require(msg.value > 0, "You must deposit a positive amount");
        amount += msg.value;
        deposited = true;
    }
    function releaseFunds() external {
        require(msg.sender == buyer, "Only buyer can release the funds");
        require(!released, "Funds are released already");
        require(!refunded, "Funds are already refunded");
        require(deposited, "Funds are not deposited yet");
        require(block.timestamp < deadline, "Deadline has passed");
        released = true;
        uint256 fundsToRelease = amount;
        amount = 0;
        (bool success, ) = payable(seller).call{value: fundsToRelease}("");
        require(success, "Transfer failed");
    }
    function refundFunds() external {
        require(!released, "Funds are released already");
        require(!refunded, "Funds are already refunded");
        require(deposited, "Funds are not deposited yet");
        require(block.timestamp >= deadline, "Deadline has not passed yet");
        require(
            msg.sender == seller || msg.sender == buyer,
            "Only seller or buyer can refund the funds"
        );
        refunded = true;
        uint256 fundsToRefund = amount;
        amount = 0;
        (bool success, ) = payable(buyer).call{value: fundsToRefund}("");
        require(success, "Transfer failed");
    }
}
