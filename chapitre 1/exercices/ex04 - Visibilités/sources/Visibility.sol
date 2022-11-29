// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Visibility {
    int public answerToLife = 42;
    int public wrongAnswerToLife = -42;
    string private sentence = "I'm a string";
    bool private isTrue = true;
    address private owner = 0xf99793f4D657F1A297dA134e66Ba81E153aD3EC8;
}
