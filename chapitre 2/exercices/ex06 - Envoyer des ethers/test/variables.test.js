const ganache = require("ganache-cli");
const provider = ganache.provider();
const Web3 = require("web3");
const web3 = new Web3(provider);
const solc = require("solc");
const fs = require("fs");
const assert = require("assert");
const mocha = require("mocha");
const { compile } = require("./compile.test");

mocha.describe("Send Ether", () => {
  const contractName = "Payable";
  let accounts = undefined;
  let contract = undefined;

  mocha.it("Send Ethers to the contract", async () => {
    const { abi, bytecode } = compile(contractName, {
      "Payable.sol": {
        content: fs.readFileSync(
          "./exercices/ex06 - Envoyer des ethers/sources/" +
            contractName +
            ".sol",
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
        value: web3.utils.toWei("2", "ether"),
      });

    // Before
    const initialuserBalance = await web3.eth.getBalance(accounts[0]);
    const initialcontractBalance = await web3.eth.getBalance(
      contract.options.address
    );
    console.log(
      "Before // User " +
        initialuserBalance +
        " / Contract " +
        initialcontractBalance
    );

    // After
    await contract.methods.sendTo().send({ from: accounts[0] });
    const finaluserBalance = await web3.eth.getBalance(accounts[0]);
    const finalcontractBalance = await web3.eth.getBalance(
      contract.options.address
    );

    console.log(
      "After // User " +
        finaluserBalance +
        " / Contract " +
        finalcontractBalance
    );

    assert.equal(finalcontractBalance, 0);
  });
});
