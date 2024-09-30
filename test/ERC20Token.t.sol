// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
// 0x2732a482c9d2aa27a924d5e25893c68558a660945551a6bf51e35cf39dcdb6d7
// ##### sepolia
// ✅  [Success]Hash: 0x2732a482c9d2aa27a924d5e25893c68558a660945551a6bf51e35cf39dcdb6d7
// Contract Address: 0xc68cAC7D69C632F76922f5e3af5aACB076AF930a
// Block: 6790605
// Paid: 0.090399464014270925 ETH (766999 gas * 117.861254075 gwei)


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
