// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Enum {
    enum myTypes {
        OWNER,
        CUSTOMER,
        FRIEND,
        DEVELOPER
    }
    myTypes choice;
    myTypes constant defaultChoice = myTypes.DEVELOPER;

    mapping(address => myTypes) public myMap;

    function getAddressType(address _address) public view returns (myTypes) {
        return myMap[_address];
    }

    function setAddressType(address _address, myTypes addressType) public {
        myMap[_address] = addressType;
    }
}
