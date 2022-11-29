// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Array {
    // int[10] array = [int(42), int(-86), int(69), int(30), int(-85563)];

    int[10] array = [int256(42), -86, 69, 30, -85563];

    function get(uint8 index) public view returns (int256) {
        return array[index];
    }

    function set(uint8 index, int256 value) public {
        array[index] = value;
    }

    function incrementArrayFor() public {
        for (uint i = 0; i < array.length; i++) {
            array[i]++;
        }
    }

    function incrementArrayWhile() public {
        uint i = 0;
        while (i < array.length) {
            array[i]++;
            i++;
        }
    }
}
