// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Struct {
    struct Soldier {
        string username;
        uint8 age;
        address account;
        string grade;
        bool isAlive;
    }

    Soldier[] public soldiers;

    mapping(address => Soldier) public soldierInfo;

    function addSoldier(
        string memory _username,
        uint8 _age,
        address _account,
        string memory _grade,
        bool _isAlive
    ) public {
        Soldier memory newSoldier;

        newSoldier.username = _username;
        newSoldier.age = _age;
        newSoldier.account = _account;
        newSoldier.grade = _grade;
        newSoldier.isAlive = _isAlive;

        soldiers.push(newSoldier);
        soldierInfo[_account] = newSoldier;
    }

    function removeSoldier(address _soldierToRemove) public {
        for (uint i = 0; i < soldiers.length; i++) {
            if (soldiers[i].account == _soldierToRemove) {
                delete soldiers[i];
            }
        }
    }

    function changeName(address _account, string memory _name) public {
        for (uint i = 0; i < soldiers.length; i++) {
            if (soldiers[i].account == _account) {
                soldiers[i].username = _name;
            }
        }
    }

    function changeAge(address _account, uint8 _age) public {
        for (uint i = 0; i < soldiers.length; i++) {
            if (soldiers[i].account == _account) {
                soldiers[i].age = _age;
            }
        }
    }

    function changeGrade(address _account, string memory _grade) public {
        for (uint i = 0; i < soldiers.length; i++) {
            if (soldiers[i].account == _account) {
                soldiers[i].grade = _grade;
                soldierInfo[_account].grade = _grade;
            }
        }
    }

    function changeAlive(address _account, bool _isAlive) public {
        for (uint i = 0; i < soldiers.length; i++) {
            if (soldiers[i].account == _account) {
                soldiers[i].isAlive = _isAlive;
            }
        }
    }

    function getSoldier(address _account) public view returns (Soldier memory) {
        return soldierInfo[_account];
    }
}
