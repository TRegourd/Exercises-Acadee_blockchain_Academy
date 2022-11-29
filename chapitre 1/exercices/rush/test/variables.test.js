const fs = require("fs");
const { compile } = require("./compile.test");

const ganache = require("ganache-cli");
const provider = ganache.provider();
const Web3 = require("web3");
const web3 = new Web3(provider);

const mocha = require("mocha");
const assert = require("assert");

mocha.describe("Distributor", () => {
  const contractName = "Distributor";
  let accounts = undefined;
  let contract = undefined;

  mocha.beforeEach(async () => {
    const { abi, bytecode } = compile(contractName, {
      "Distributor.sol": {
        content: fs.readFileSync(
          "./exercices/rush/sources/" + contractName + ".sol",
          "utf-8"
        ),
      },
    });
    accounts = await web3.eth.getAccounts();
    contract = await new web3.eth.Contract(abi)
      .deploy({ data: bytecode.object.toString() })
      .send({ from: accounts[0], gas: 3000000 });
  });
  mocha.it("has been deployed", () => {
    assert.ok(contract.options.address);
  });

  mocha.it("Should Create COCA item with stock to 5", async () => {
    await contract.methods
      .createItem("COCA", web3.utils.toWei("1", "ether"), 10, 5)
      .send({ from: accounts[0], gas: 3000000 });
    const coca = await contract.methods.stock("COCA").call();
    assert.equal(coca.quantity, 5);
  });

  mocha.it(
    "Should buy COCA item, change distributor's stock to 4 and account[1]'s to 1",
    async () => {
      await contract.methods
        .createItem("COCA", web3.utils.toWei("1", "ether"), 10, 5)
        .send({ from: accounts[0], gas: 3000000 });
      await contract.methods.buyItem("COCA", 1).send({
        from: accounts[1],
        gas: 300000,
        value: web3.utils.toWei("1", "ether"),
      });

      const account1Cocainventory = await contract.methods
        .personnalInventory(accounts[1], "COCA")
        .call();

      const cocaStock = await contract.methods.stock("COCA").call();

      assert.equal(account1Cocainventory, 1);
      assert.equal(cocaStock.quantity, 4);
    }
  );
});
