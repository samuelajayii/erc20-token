// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {Token} from "../src/ERC20Token.sol";

contract DeployToken is Script {
    function run() external {
        vm.startBroadcast();

        vm.stopBroadcast();
    }
}
