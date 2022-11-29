// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Variables {
    int public answerToLife = 42;
    int public wrongAnswerToLife = -42;
    string public sentence = "I'm a string";
    bool public isTrue = true;
    address public owner = msg.sender;
}
