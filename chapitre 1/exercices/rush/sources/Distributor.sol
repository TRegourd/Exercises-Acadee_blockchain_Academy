// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract Distributor is Ownable {
    struct ItemStruct {
        string name;
        uint256 price;
        uint256 limit;
        uint256 quantity;
    }

    mapping(address => mapping(string => uint)) public personnalInventory;
    mapping(string => ItemStruct) public stock;

    function createBaseItem() public onlyOwner {
        stock["coca"] = ItemStruct("coca", 1 * 1 ether, 15, 5);
        stock["fanta"] = ItemStruct("fanta", 1 * 1 ether, 15, 5);
        stock["ice_tea"] = ItemStruct("ice_tea", 1 * 1 ether, 15, 5);
    }

    function withdrawDistributor() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function createItem(
        string memory _name,
        uint _price,
        uint _limit,
        uint _initialQty
    ) public onlyOwner {
        stock[_name] = ItemStruct(_name, _price, _limit, _initialQty);
    }

    function buyItem(string memory _item, uint _qty) public payable {
        require(msg.value == stock[_item].price * _qty);
        personnalInventory[msg.sender][_item] =
            personnalInventory[msg.sender][_item] +
            _qty;
        stock[_item].quantity = stock[_item].quantity - _qty;
    }

    function reloadItem(string memory _item, uint _qty) public onlyOwner {
        require(stock[_item].quantity + _qty <= stock[_item].limit);
        stock[_item].quantity = stock[_item].quantity + _qty;
    }

    function updateItemPrice(string memory _item, uint _newPrice)
        public
        onlyOwner
    {
        stock[_item].price = _newPrice;
    }

    function updateItemMaxQty(string memory _item, uint _newMaxQty)
        public
        onlyOwner
    {
        stock[_item].limit = _newMaxQty;
    }
}
