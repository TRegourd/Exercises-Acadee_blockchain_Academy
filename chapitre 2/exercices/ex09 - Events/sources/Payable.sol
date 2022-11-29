// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Payable {
    constructor() payable {}

    event Transaction(address _to, uint _amount);

    function sendTo() public {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
        emit Transaction(msg.sender, balance);
    }

    function destroySmartContract(address payable _recipient) public {
        selfdestruct(_recipient);
    }
}
