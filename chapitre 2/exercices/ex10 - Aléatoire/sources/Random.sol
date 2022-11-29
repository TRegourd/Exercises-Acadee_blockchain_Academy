// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Random {
    function getRandom(string memory _string) public view returns (uint) {
        uint256 rand = uint((keccak256(abi.encode(_string)))) / block.number;
        return rand;
    }
}
