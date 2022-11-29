// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

interface Counter {
    function increment() external;

    function reset() external;

    function setCount(uint _count) external;

    function getValue() external view returns (uint);
}
