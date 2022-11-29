// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Modifier {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    function onlyOwner() public view isOwner returns (bool) {
        return true;
    }
}
