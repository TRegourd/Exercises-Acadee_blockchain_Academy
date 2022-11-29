const ganache = require("ganache-cli");
const provider = ganache.provider();
const Web3 = require("web3");
const web3 = new Web3(provider);
const solc = require("solc");
const fs = require("fs");
const assert = require("assert");
const mocha = require("mocha");
const { compile } = require("./compile.test");

mocha.describe("Fallback", () => {
  const contractName = "Fallback";
  let accounts = undefined;
  let contract = undefined;

  mocha.it("Goes to the fallback", async () => {
    const { abi, bytecode } = compile(contractName, {
      "Fallback.sol": {
        content: fs.readFileSync(
          "./exercices/ex07 - Fallback/sources/" + contractName + ".sol",
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

    try {
      await web3.eth.sendTransaction({
        from: accounts[0],
        to: contract.options.address,
        data: accounts[0], // Wrong data sent , if "null", will go to receive.
      });
      const counter = await contract.methods.counter().call();
      console.log("counter: " + counter);
      assert.equal(counter, 1);
    } catch {
      console.log("function not found...");
    }
  });
});
