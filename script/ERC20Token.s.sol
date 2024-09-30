// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {Token} from "../src/ERC20Token.sol";

contract DeployToken is Script {
    uint256 public constant CAP = 20000000 * 10 ** 18;
    uint256 public constant INITIAL_REWARD = 500;
    address public constant owner = 0x5d793E1DAaC377C270E7c0aFf796242a3fBaC635;

    function run() external returns (Token) {
        vm.startBroadcast(owner);
        Token myToken = new Token(CAP, INITIAL_REWARD);
        vm.stopBroadcast();
        return myToken;
    }
}
