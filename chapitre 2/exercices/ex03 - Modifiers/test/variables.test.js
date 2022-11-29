const ganache = require("ganache-cli");
const provider = ganache.provider();
const Web3 = require("web3");
const web3 = new Web3(provider);
const solc = require("solc");
const fs = require("fs");
const assert = require("assert");
const mocha = require("mocha");
const { compile } = require("./compile.test");

mocha.describe("Modifiers", () => {
  const contractName = "Modifier";
  let accounts = undefined;
  let contract = undefined;

  mocha.beforeEach(async () => {
    const { abi, bytecode } = compile(contractName, {
      "Modifier.sol": {
        content: fs.readFileSync(
          "./exercices/ex03 - Modifiers/sources/" + contractName + ".sol",
          "utf-8"
        ),
      },
    });
    accounts = await web3.eth.getAccounts();
    contract = await new web3.eth.Contract(abi)
      .deploy({ data: bytecode.object.toString() })
      .send({ from: accounts[0], gas: 300000 });
  });

  mocha.it("Deploy the contract", async () => {
    assert.ok(contract.options.address);
  });

  mocha.it("Test with good owner", async () => {
    try {
      const res = await contract.methods
        .onlyOwner()
        .call({ from: accounts[0] });
      assert.equal(res, true);
    } catch (e) {
      assert.equal(false, true);
    }
  });

  mocha.it("Test with wrong owner", async () => {
    try {
      await contract.methods.onlyOwner().call({ from: accounts[1] });
      assert.equal(false, true);
    } catch (e) {
      assert.equal(true, true);
    }
  });
});
