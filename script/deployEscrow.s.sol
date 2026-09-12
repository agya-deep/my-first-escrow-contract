// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Escrow} from "../src/escrow.sol";

contract DeployEscrow is Script {
    function run() external {
        vm.startBroadcast();
        new Escrow(makeAddr("seller"), makeAddr("buyer"), 10 days);
        vm.stopBroadcast();
    }
}
