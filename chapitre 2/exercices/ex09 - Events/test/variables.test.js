const ganache = require("ganache-cli");
const provider = ganache.provider();
const Web3 = require("web3");
const web3 = new Web3(provider);
const solc = require("solc");
const fs = require("fs");
const assert = require("assert");
const mocha = require("mocha");
const { compile } = require("./compile.test");

mocha.describe("Events", () => {
  const contractName = "Payable";
  let accounts = undefined;
  let contract = undefined;

  mocha.it("Emits an event at transaction", async () => {
    const { abi, bytecode } = compile(contractName, {
      "Payable.sol": {
        content: fs.readFileSync(
          "./exercices/ex09 - Events/sources/" + contractName + ".sol",
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

    let options = {
      filter: {
        _amount: ["10"],
      },
      fromBlock: 0,
    };

    // Cette fonction permet de dire que je veux ecouter les events `Transaction` de mon contract
    // on. est une function qui va lire la valeur contenu dans `data` a chaque fois que mon event est appeler dans le contract
    // await contract.events
    //   .Transaction(options)
    //   .on("data", (event) => console.log(event.returnValues));

    // Je declanche deux event en envoyer des ethers sur mon contract
    await contract.methods.sendTo().send({
      from: accounts[0],
    });
    await contract.methods.sendTo().send({
      from: accounts[1],
    });

    // cette fonction permet de dire que je souhaite recuperer toutes les transactions de mon contract
    // Qui s'appel `Received` et les afficher
    const myEvents = await contract.getPastEvents("Transaction", options);
    // console.log(myEvents);
  });
});
