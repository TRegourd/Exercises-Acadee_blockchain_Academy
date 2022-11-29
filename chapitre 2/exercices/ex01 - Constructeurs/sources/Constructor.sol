// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Constructor {
    uint public myVar;

    constructor(uint myParam_) {
        myVar = myParam_;
    }
}
