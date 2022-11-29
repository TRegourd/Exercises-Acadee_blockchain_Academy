// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Array {
    int[10] array = [int(42), int(-86), int(69), int(30), int(-85563)];

    function get(uint8 index) public view returns (int256) {
        return array[index];
    }

    function set(uint8 index, int256 value) public {
        array[index] = value;
    }
}
