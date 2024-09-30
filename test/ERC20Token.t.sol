// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26; 

import {Test} from "forge-std/Test.sol";
import {Token} from "../src/ERC20Token.sol";
import {console} from "forge-std/console.sol";
import {DeployToken} from "../script/ERC20Token.s.sol";

contract TokenTest is Test {
    Token public myToken;
    DeployToken public deployer;
    address public owner = 0x5d793E1DAaC377C270E7c0aFf796242a3fBaC635;
    address public miner = makeAddr("miner");
    address public bob = makeAddr("bob");
    uint256 public constant SET_REWARD = 100;

    function setUp() public {
        vm.prank(owner);
        deployer = new DeployToken();
        myToken = deployer.run();
    }

    function testDeployment() public {
        vm.prank(owner);
        assertEq(myToken.totalSupply(), 7000000 * 10 ** 18);
        assertEq(myToken.owner(), owner);
        assertEq(myToken.blockReward(), 500 * 10 ** 18);
    }

    function testMintReward() public {
        // make the miner the owner of the block reward
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

    function testUpdate() public {
        vm.prank(owner);
        myToken.transfer(bob, 200 * 10 ** 18);
        assertEq(myToken.balanceOf(owner), (7000000 * 10 ** 18) - 200 * 10 ** 18);
        assertEq(myToken.balanceOf(bob), 200 * 10 ** 18);
    }
}
