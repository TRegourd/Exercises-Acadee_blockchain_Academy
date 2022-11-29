const ganache = require("ganache-cli");
const provider = ganache.provider();
const Web3 = require("web3");
const web3 = new Web3(provider);
const solc = require("solc");
const fs = require("fs");
const assert = require("assert");
const mocha = require("mocha");
const { compile } = require("./compile.test");

mocha.describe("Random", () => {
  const contractName = "Random";
  let accounts = undefined;
  let contract = undefined;

  mocha.it("Generates random numbers", async () => {
    const { abi, bytecode } = compile(contractName, {
      "Random.sol": {
        content: fs.readFileSync(
          "./exercices/ex10 - Aléatoire/sources/" + contractName + ".sol",
          "utf-8"
        ),
      },
    });
    accounts = await web3.eth.getAccounts();
    contract = await new web3.eth.Contract(abi)
      .deploy({ data: bytecode.object.toString() })
      .send({
        from: accounts[0],
        gas: 300000,
      });

    assert.notEqual(
      await contract.methods.getRandom("toto").call(),
      await contract.methods.getRandom("tata").call()
    );
  });
});
