// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Escrow} from "../src/escrow.sol";

contract EscrowTest is Test {
    Escrow escrow;
    address seller = makeAddr("seller");
    address buyer = makeAddr("buyer");

    function setUp() public {
        escrow = new Escrow(seller, buyer, 10 days);
    }

    function testBuyerCanDeposit() public {
        vm.deal(buyer, 1 ether);
        vm.prank(buyer);
        escrow.deposit{value: 1 ether}();
        assertEq(escrow.amount(), 1 ether);
        assertTrue(escrow.deposited());
    }
    function testNonBuyerCannotDeposit() public {
        vm.deal(seller, 1 ether);
        vm.prank(seller);
        vm.expectRevert("Only buyer can deposit");
        escrow.deposit{value: 1 ether}();
        assertEq(escrow.amount(), 0);
        assertFalse(escrow.deposited());
    }
    function testCannotDepositTwice() public {
        vm.deal(buyer, 2 ether);
        vm.prank(buyer);
        escrow.deposit{value: 1 ether}();

        vm.prank(buyer);
        vm.expectRevert("Funds are already deposited");
        escrow.deposit{value: 1 ether}();
    }
    function testBuyerCanRelease() public {
        vm.deal(buyer, 1 ether);
        vm.prank(buyer);
        escrow.deposit{value: 1 ether}();

        uint256 sellerBalanceBefore = seller.balance;
        vm.prank(buyer);
        escrow.releaseFunds();
        uint256 sellerbalanceAfter = seller.balance;
        assertEq(sellerbalanceAfter - sellerBalanceBefore, 1 ether);
        assertTrue(escrow.released());
    }
    function testNonBuyerCannotRelease() public {
        vm.deal(buyer, 1 ether);
        vm.prank(buyer);
        escrow.deposit{value: 1 ether}();

        vm.prank(seller);
        vm.expectRevert("Only buyer can release the funds");
        escrow.releaseFunds();
        assertFalse(escrow.released());
    }
    function testCannotReleaseWithoutDeposit() public {
        vm.prank(buyer);
        vm.expectRevert("Funds are not deposited yet");
        escrow.releaseFunds();
        assertFalse(escrow.released());
    }
    function testCannotRefundBeforeDeadline() public {
        vm.deal(buyer, 1 ether);
        vm.prank(buyer);
        escrow.deposit{value: 1 ether}();

        vm.warp(block.timestamp + 5 days);
        vm.prank(buyer);
        vm.expectRevert("Deadline has not passed yet");
        escrow.refundFunds();
        assertFalse(escrow.refunded());
    }
    function testBuyerCanRefundAfterDeadline() public {
        vm.deal(buyer, 1 ether);
        vm.prank(buyer);
        escrow.deposit{value: 1 ether}();
        vm.warp(block.timestamp + 10 days);

        vm.prank(buyer);

        escrow.refundFunds();
        assertEq(buyer.balance, 1 ether);

        assertTrue(escrow.refunded());
        assertEq(escrow.amount(), 0);
    }
    function testSellerCanRefundAfterDeadline() public {
        vm.deal(buyer, 1 ether);
        vm.prank(buyer);
        escrow.deposit{value: 1 ether}();
        vm.warp(block.timestamp + 10 days);

        vm.prank(seller);
        escrow.refundFunds();
        assertEq(buyer.balance, 1 ether);

        assertTrue(escrow.refunded());
        assertEq(escrow.amount(), 0);
    }
    function testCannotReleaseTwice() public {
        vm.deal(buyer, 1 ether);
        vm.prank(buyer);
        escrow.deposit{value: 1 ether}();

        vm.prank(buyer);
        escrow.releaseFunds();

        vm.prank(buyer);
        vm.expectRevert("Funds are released already");
        escrow.releaseFunds();
    }
    function testCannotReleaseAfterDeadline() public {
        vm.deal(buyer, 1 ether);
        vm.prank(buyer);
        escrow.deposit{value: 1 ether}();
        vm.warp(block.timestamp + 11 days);

        vm.prank(buyer);
        vm.expectRevert();
        escrow.releaseFunds();
    }
    function testCannotRefundTwice() public {
        vm.deal(buyer, 1 ether);
        vm.prank(buyer);
        escrow.deposit{value: 1 ether}();
        vm.warp(block.timestamp + 11 days);

        vm.prank(buyer);
        escrow.refundFunds();

        vm.prank(buyer);
        vm.expectRevert("Funds are already refunded");
        escrow.refundFunds();
    }
    function testCannotRefundAfterRelease() public {
        vm.deal(buyer, 1 ether);
        vm.prank(buyer);
        escrow.deposit{value: 1 ether}();

        vm.prank(buyer);
        escrow.releaseFunds();

        vm.prank(buyer);
        vm.expectRevert("Funds are released already");
        escrow.refundFunds();
    }
    function testCannotReleaseAfterRefund() public {
        vm.deal(buyer, 1 ether);
        vm.prank(buyer);
        escrow.deposit{value: 1 ether}();
        vm.warp(block.timestamp + 11 days);

        vm.prank(buyer);
        escrow.refundFunds();

        vm.prank(buyer);
        vm.expectRevert("Funds are already refunded");
        escrow.releaseFunds();
    }
}
