// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

import "./Marketplace.sol";

contract Transaction is Ownable {
    event BuyOffer(
        uint indexed _productId,
        address indexed _buyer,
        uint _priceOffer,
        uint _timeStamp
    );

    event AcceptedOffer(
        uint indexed _productId,
        address indexed _buyer,
        address indexed _seller,
        uint _price
    );

    event SuccessfullTransaction(
        uint indexed _productId,
        address indexed _buyer,
        address indexed _seller,
        uint _price
    );

    event CodeGenerated(
        uint indexed _productId,
        address indexed _buyer,
        address indexed _seller,
        uint _price,
        bytes32 _code
    );

    Marketplace marketplace;

    constructor(Marketplace _contractAddress) {
        marketplace = _contractAddress;
    }

    function linkMarketplaceContract(Marketplace _contractAddress)
        public
        onlyOwner
    {
        marketplace = _contractAddress;
    }

    function withdrawContractFunds() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    modifier onlySeller(uint _productId) {
        require(
            marketplace.getProduct(_productId).owner == msg.sender ||
                validatedTransactions[_productId].seller == msg.sender
        );
        _;
    }

    modifier onlyBuyer(uint _productId) {
        require(validatedTransactions[_productId].seller == msg.sender);
        _;
    }

    struct Offer {
        uint256 price;
        address buyer;
        uint timestamp;
    }

    struct ValidatedOffer {
        uint256 productId;
        address buyer;
        address seller;
        uint256 price;
    }

    mapping(uint256 => Offer[]) public pendingTransactions;
    mapping(uint256 => ValidatedOffer) public validatedTransactions;

    function placeOrder(uint _productId) public payable {
        require(
            marketplace.getProduct(_productId).owner != msg.sender &&
                marketplace.getProduct(_productId).price <= msg.value &&
                validatedTransactions[_productId].buyer == address(0)
        );
        pendingTransactions[_productId].push(
            Offer(msg.value, msg.sender, block.timestamp)
        );
        emit BuyOffer(_productId, msg.sender, msg.value, block.timestamp);
    }

    function approveOffer(uint _productId, uint _acceptedOfferId)
        public
        onlySeller(_productId)
    {
        uint currentDate = block.timestamp;
        uint offerDate = pendingTransactions[_productId][_acceptedOfferId]
            .timestamp;
        require(currentDate <= (offerDate + 3 days));

        validatedTransactions[_productId] = ValidatedOffer(
            _productId,
            pendingTransactions[_productId][_acceptedOfferId].buyer,
            msg.sender,
            pendingTransactions[_productId][_acceptedOfferId].price
        );

        emit AcceptedOffer(
            _productId,
            pendingTransactions[_productId][_acceptedOfferId].buyer,
            msg.sender,
            pendingTransactions[_productId][_acceptedOfferId].price
        );

        Offer[] memory allPendingOffers = pendingTransactions[_productId];

        delete pendingTransactions[_productId];

        for (uint i = 0; i < allPendingOffers.length; i++) {
            if (i != _acceptedOfferId) {
                payable(allPendingOffers[i].buyer).transfer(
                    allPendingOffers[i].price
                );
            }
        }
    }

    function unlockFunds(uint _productId) public onlyBuyer(_productId) {
        ValidatedOffer memory validatedOffer = validatedTransactions[
            _productId
        ];

        delete validatedTransactions[_productId];

        marketplace.updateProductOwner(_productId, validatedOffer.buyer);
        // FIXME Obligé de passer par une function updateProductOwner dans le contract Marketplace ? -- Securité pour ne pas que qqun s'approprie un objet ?

        payable(validatedOffer.seller).transfer(
            (validatedOffer.price * 95) / 100
        );
    }

    function unlockFundsWithCode(uint _productId) public onlyBuyer(_productId) {
        bytes32 codeHash = keccak256(
            abi.encode(
                _productId,
                msg.sender,
                validatedTransactions[_productId].seller,
                validatedTransactions[_productId].price
            )
        );

        validatedTransactions[_productId] = ValidatedOffer(
            _productId,
            msg.sender,
            validatedTransactions[_productId].seller,
            validatedTransactions[_productId].price
        );

        emit CodeGenerated(
            _productId,
            msg.sender,
            validatedTransactions[_productId].seller,
            validatedTransactions[_productId].price,
            codeHash
        );
    }

    function ValidateTransactionWithCode(uint _productId, bytes32 _code)
        public
        onlySeller(_productId)
    {
        uint256 productId = validatedTransactions[_productId].productId;
        address seller = msg.sender;
        address buyer = validatedTransactions[_productId].buyer;
        uint256 price = validatedTransactions[_productId].price;

        require(
            keccak256(abi.encode(productId, buyer, seller, price)) == _code,
            "Invalid transaction"
        );

        delete validatedTransactions[_productId];

        emit SuccessfullTransaction(productId, buyer, seller, price);

        marketplace.updateProductOwner(_productId, buyer);

        payable(msg.sender).transfer((price * 95) / 100);
    }

    function cancelOffer(uint _productId) public {
        Offer[] memory allPendingOffers = pendingTransactions[_productId];

        for (uint i = 0; i < allPendingOffers.length; i++) {
            if (allPendingOffers[i].buyer == msg.sender) {
                delete pendingTransactions[_productId][i];
                payable(allPendingOffers[i].buyer).transfer(
                    allPendingOffers[i].price
                );
            }
        }
    }
}
