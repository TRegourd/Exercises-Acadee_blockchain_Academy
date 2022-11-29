const ganache = require("ganache-cli");
const provider = ganache.provider();
const Web3 = require("web3");
const web3 = new Web3(provider);
const solc = require("solc");
const fs = require("fs");
const assert = require("assert");
const mocha = require("mocha");

const input = {
  language: "Solidity",
  sources: {
    "Constructor.sol": {
      content: fs.readFileSync(
        "./exercices/ex01 - Constructeurs/sources/Constructor.sol",
        "utf-8"
      ),
    },
  },
  settings: {
    outputSelection: {
      "*": {
        "*": ["*"],
      },
    },
  },
};
const { contracts } = JSON.parse(solc.compile(JSON.stringify(input)));
const abi = contracts["Constructor.sol"]["Constructor"].abi;
const bytecode = contracts["Constructor.sol"]["Constructor"].evm.bytecode;

const getAccounts = async () => {
  return await web3.eth.getAccounts();
};

mocha.describe("Constructeur", () => {
  mocha.it("Verify Constructeur", async () => {
    try {
      const accounts = await getAccounts();
      const contract = await new web3.eth.Contract(abi)
        .deploy({ arguments: [12], data: bytecode.object })
        .send({ from: accounts[0], gas: 1000000 });

      const res = await contract.methods.myVar().call();
      assert.equal(res, 12);
    } catch (e) {
      console.error(e);
    }
  });
});
