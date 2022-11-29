// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Fallback {
    uint public counter;

    fallback() external {
        counter = counter + 1;
    }

    receive() external payable {}
}
