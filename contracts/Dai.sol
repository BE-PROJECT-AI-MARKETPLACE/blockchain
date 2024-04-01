// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Dai is ERC20 {
    constructor() ERC20("Dai stablecoin", "DAI") {}

function stringToAddress(string memory _address) internal pure returns (address) {
        bytes memory b = bytes(_address);
        require(b.length == 42 && b[0] == '0' && (b[1] == 'x' || b[1] == 'X'), "Invalid address format");

        uint result = 0;
        for (uint i = 2; i < b.length; i++) {
            uint char = uint(uint8(b[i]));
            if (char >= 48 && char <= 57) {
                result = result * 16 + (char - 48);
            } else if (char >= 65 && char <= 70) {
                result = result * 16 + (char - 55);
            } else if (char >= 97 && char <= 102) {
                result = result * 16 + (char - 87);
            } else {
                revert("Invalid character");
            }
        }
        return address(uint160(result));
    }
    function faucet(string memory to, uint amount) external returns (uint256) {

        _mint(stringToAddress(to), amount);
        return balanceOf(stringToAddress(to));
    }
}
