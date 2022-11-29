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

contract Marketplace is Ownable {
    event ProductCreated(
        uint productId,
        string indexed productName,
        string indexed productDescription,
        uint productPrice,
        address indexed productCreator
    );

    struct Product {
        address owner;
        string name;
        string description;
        uint256 price;
    }

    mapping(uint => Product) public productDetails;

    uint256 public productIdCounter;

    function createBaseProduct() public {
        productDetails[productIdCounter] = Product(
            msg.sender,
            "Livre",
            "Un Livre",
            1 ether
        );
        productIdCounter++;
        productDetails[productIdCounter] = Product(
            msg.sender,
            "Voiture",
            "Une Voiture",
            50 ether
        );
        productIdCounter++;
        productDetails[productIdCounter] = Product(
            msg.sender,
            "TV",
            "Une TV",
            10 ether
        );
        productIdCounter++;
    }

    function createProduct(
        string memory _name,
        string memory _description,
        uint256 _price
    ) public {
        productDetails[productIdCounter] = Product(
            msg.sender,
            _name,
            _description,
            _price
        );
        productIdCounter++;
        emit ProductCreated(
            productIdCounter,
            _name,
            _description,
            _price,
            msg.sender
        );
    }

    function getProduct(uint _productId) public view returns (Product memory) {
        return productDetails[_productId];
    }

    function updateProductOwner(uint _productId, address _newOwner) external {
        // require(tx.origin == productDetails[_productId].owner);
        productDetails[_productId].owner = _newOwner;
    }
}
