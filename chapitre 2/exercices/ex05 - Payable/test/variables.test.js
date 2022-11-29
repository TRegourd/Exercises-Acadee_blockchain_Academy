const ganache = require("ganache-cli");
const provider = ganache.provider();
const Web3 = require("web3");
const web3 = new Web3(provider);
const solc = require("solc");
const fs = require("fs");
const assert = require("assert");
const mocha = require("mocha");
const { compile } = require("./compile.test");

mocha.describe("Payable", () => {
  const contractName = "Payable";
  let accounts = undefined;
  let contract = undefined;

  mocha.beforeEach(async () => {
    const { abi, bytecode } = compile(contractName, {
      "Payable.sol": {
        content: fs.readFileSync(
          "./exercices/ex05 - Payable/sources/" + contractName + ".sol",
          "utf-8"
        ),
      },
    });
    accounts = await web3.eth.getAccounts();
    contract = await new web3.eth.Contract(abi)
      .deploy({ data: bytecode.object.toString() })
      .send({ from: accounts[0], gas: 300000, value: 3 });
  });

  mocha.it("Deploy the contract with ether", async () => {
    assert.ok(contract.options.address);
  });
});
