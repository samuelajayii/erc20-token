// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Capped} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract Token is ERC20Capped, ERC20Burnable {
    address payable public immutable owner;
    uint256 public blockReward;

    constructor(uint256 cap, uint256 reward) ERC20("SamKen", "SAM") ERC20Capped(cap * 10 ** 18) {
        owner = payable(msg.sender);
        _mint(msg.sender, 7000000 * 10 ** 18);
        blockReward = reward * 10 ** 18;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner may do this");
        _;
    }

    function mintMinerReward() external {
        require(totalSupply() < cap(), "Token Cap reached");
        _mint(block.coinbase, blockReward);
    }

    function setReward(uint256 reward) public onlyOwner {
        blockReward = reward * 10 ** 18;
    }

    function _update(address from, address to, uint256 value) internal virtual override(ERC20, ERC20Capped) {
        super._update(from, to, value); // Call the base implementations
    }
}
