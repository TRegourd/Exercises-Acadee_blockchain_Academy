// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract ItSReallyEasy {
    address public entrant;
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier gasConsume() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier isNotAContract() {
        require((gasleft() % 984) == 0);
        _;
    }

    function ItSSuperEasy() public isNotAContract gasConsume {
        owner = msg.sender;
    }
}
