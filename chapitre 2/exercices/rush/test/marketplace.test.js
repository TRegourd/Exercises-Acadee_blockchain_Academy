const ganache = require("ganache-cli");
const provider = ganache.provider();
const Web3 = require("web3");
const web3 = new Web3(provider);
const solc = require("solc");
const fs = require("fs");
const assert = require("assert");
const mocha = require("mocha");
const { compile } = require("./compile.test");

mocha.describe("MarketPlace", () => {
  let accounts = undefined;
  let contract_marketplace = undefined;
  let contract_transaction = undefined;
  let items = [];

  mocha.beforeEach("Deploy the 2 contracts", async () => {
    accounts = await web3.eth.getAccounts();

    const contract_marketplace_name = "Marketplace";
    const marketplace = compile(contract_marketplace_name, {
      "Marketplace.sol": {
        content: fs.readFileSync(
          "./exercices/rush/sources/" + contract_marketplace_name + ".sol",
          "utf-8"
        ),
      },
    });

    contract_marketplace = await new web3.eth.Contract(marketplace.abi)
      .deploy({ data: marketplace.bytecode.object })
      .send({ from: accounts[0], gas: 3000000 });

    items = [
      {
        owner: accounts[0],
        name: "Livre",
        description: "Un livre",
        price: web3.utils.toWei("2", "ether"),
      },
      {
        owner: accounts[0],
        name: "Voiture",
        description: "Une Voiture",
        price: web3.utils.toWei("50", "ether"),
      },
      {
        owner: accounts[0],
        name: "TV",
        description: "Une TV",
        price: web3.utils.toWei("10", "ether"),
      },
    ];

    for (let i = 0; i < items.length; i++) {
      await contract_marketplace.methods
        .createProduct(items[i].name, items[i].description, items[i].price)
        .send({ from: accounts[0], gas: 3000000 });
    }

    const contract_transaction_name = "Transaction";
    const transaction = compile(contract_transaction_name, {
      "Transaction.sol": {
        content: fs.readFileSync(
          "./exercices/rush/sources/" + contract_transaction_name + ".sol",
          "utf-8"
        ),
      },
    });

    contract_transaction = await new web3.eth.Contract(transaction.abi)
      .deploy({
        arguments: [contract_marketplace.options.address],
        data: transaction.bytecode.object,
      })
      .send({ from: accounts[0], gas: 3000000 });
  });

  mocha.it("Should have deployed Marketplace the contract", async () => {
    assert.ok(contract_marketplace.options.address);
  });

  mocha.it("Should have deployed Transaction the contract", async () => {
    assert.ok(contract_transaction.options.address);
  });

  mocha.it("Should have created 3 items", async () => {
    for (let i = 0; i < 3; i++) {
      const { owner, name, description, price } =
        await contract_marketplace.methods.getProduct(i).call();

      assert.equal(owner, items[i].owner);
      assert.equal(name, items[i].name);
      assert.equal(description, items[i].description);
      assert.equal(price, items[i].price);
    }
  });

  mocha.it(
    "Should place an offer on item 0 from account 1 with enough ethers",
    async () => {
      await contract_transaction.methods
        .placeOrder(0)
        .send({ from: accounts[1], gas: 3000000, value: items[0].price });

      const { price, buyer } = await contract_transaction.methods
        .pendingTransactions(0, 0)
        .call();
      assert.equal(buyer, accounts[1]);
      assert.equal(price, items[0].price);
    }
  );

  mocha.it(
    "Should refuse an offer on item 0 from account 1 without enough ethers",
    async () => {
      const wrongPrice = web3.utils.toWei("1", "ether");
      let res = undefined;
      try {
        res = await contract_transaction.methods.placeOrder(0).send({
          from: accounts[1],
          gas: 3000000,
          value: wrongPrice,
        });
        assert.equal(res, undefined);
      } catch (err) {
        assert.equal(res, undefined);
      }
    }
  );

  mocha.it("Should accept offer 0 for item 0 from account 0", async () => {
    const transactionValue = items[0].price;
    await contract_transaction.methods
      .placeOrder(0)
      .send({ from: accounts[1], gas: 3000000, value: transactionValue });

    const res = await contract_transaction.methods
      .approveOffer(0, 0)
      .send({ from: accounts[0], gas: 3000000 });

    assert.equal(
      res.events.AcceptedOffer.returnValues["_price"],
      transactionValue
    );
    assert.equal(res.events.AcceptedOffer.returnValues["_buyer"], accounts[1]);
    assert.equal(res.events.AcceptedOffer.returnValues["_seller"], accounts[0]);
  });

  mocha.it(
    "Should refuse offer 0 for item 0 from account 2 (not the owner)",
    async () => {
      const transactionValue = items[0].price;
      await contract_transaction.methods
        .placeOrder(0)
        .send({ from: accounts[1], gas: 3000000, value: transactionValue });
      let res = undefined;
      try {
        res = await contract_transaction.methods
          .approveOffer(0, 0)
          .send({ from: accounts[2], gas: 3000000 });
        assert.equal(res, undefined);
      } catch (e) {
        assert.equal(res, undefined);
      }
    }
  );

  mocha.it("Should transfer ownership when buyer unlock funds", async () => {
    const transactionValue = items[0].price;
    await contract_transaction.methods
      .placeOrder(0)
      .send({ from: accounts[1], gas: 3000000, value: transactionValue });

    await contract_transaction.methods
      .approveOffer(0, 0)
      .send({ from: accounts[0], gas: 3000000 });

    await contract_transaction.methods
      .unlockFunds(0)
      .send({ from: accounts[1], gas: 3000000 });

    const { owner } = await contract_marketplace.methods.getProduct(0).call();

    assert.equal(owner, accounts[1]);
  });

  mocha.it(
    "Should transfer ownership when seller unlock funds with code",
    async () => {
      const transactionValue = items[0].price;
      await contract_transaction.methods
        .placeOrder(0)
        .send({ from: accounts[1], gas: 3000000, value: transactionValue });

      await contract_transaction.methods
        .approveOffer(0, 0)
        .send({ from: accounts[0], gas: 3000000 });

      const res = await contract_transaction.methods
        .unlockFundsWithCode(0)
        .send({ from: accounts[1], gas: 3000000 });

      await contract_transaction.methods
        .ValidateTransactionWithCode(
          0,
          res.events.CodeGenerated.returnValues["_code"]
        )
        .send({ from: accounts[0], gas: 3000000 });

      const { owner } = await contract_marketplace.methods.getProduct(0).call();

      assert.equal(owner, accounts[1]);
    }
  );
});
