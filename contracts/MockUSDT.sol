// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract USDT is ERC20 {
    constructor() ERC20("USD Tether", "USDT") {
        _mint(msg.sender, 2_000_000 * 10 ** decimals());
    }

    function faucet(uint256 _amount) external {
        _mint(msg.sender, _amount);
    }

    function decimals() public pure override returns (uint8){
        return 6;
    }
}