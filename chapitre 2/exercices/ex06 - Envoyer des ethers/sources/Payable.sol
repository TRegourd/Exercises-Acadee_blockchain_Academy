// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Payable {
    constructor() payable {}

    function sendTo() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}
