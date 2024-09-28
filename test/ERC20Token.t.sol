// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {Token} from "../src/ERC20Token.sol";
import {console} from "forge-std/console.sol";
import {DeployToken} from "../script/ERC20Token.s.sol";

contract TokenTest is Test {
    Token public myToken;
    DeployToken public deployer;
    uint256 public constant CAP = 70000000000000000000000000;
    uint256 public constant INITIAL_REWARD = 500;
    address public owner = address(0x1);
    address public miner = makeAddr("miner");
    address public bob = makeAddr("bob");
    uint256 public constant SET_REWARD = 100;

    function setUp() public {
        deployer = new DeployToken();
        vm.prank(owner);
        myToken = new Token(CAP, INITIAL_REWARD);
    }

    function testDeployment() public {
        assertEq(myToken.totalSupply(), 70000000 * 10 ** 18);
        assertEq(myToken.owner(), owner);
        assertEq(myToken.blockReward(), INITIAL_REWARD * 10 ** 18);
    }

    function testMintReward() public {
        vm.coinbase(miner);
        // Get the miner's initial balance before minting the reward
        uint256 initialBalance = myToken.balanceOf(miner);
        // Call mintMinerReward() function
        myToken.mintMinerReward();
        // Get the miner's balance after the reward is minted
        uint256 finalBalance = myToken.balanceOf(miner);
        // Check if the reward is correctly added to the miner's balance
        assertEq(finalBalance, initialBalance + myToken.blockReward());
    }

    function testOnlyOwner() public {
        vm.expectRevert();
        vm.prank(bob);
        myToken.setReward(SET_REWARD);

        vm.prank(owner);
        myToken.setReward(300);
        assertEq(myToken.blockReward(), 300 * 10 ** 18);
    }

    function testUpdate() public {}
}
