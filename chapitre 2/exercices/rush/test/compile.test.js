const solc = require("solc");
const fs = require("fs");

function compile(contractName, content) {
  const input = {
    language: "Solidity",
    sources: {
      "Marketplace.sol": {
        content: fs.readFileSync(
          "./exercices/rush/sources/Marketplace.sol",
          "utf-8"
        ),
      },
      "Transaction.sol": {
        content: fs.readFileSync(
          "./exercices/rush/sources/Transaction.sol",
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

  const contracts = JSON.parse(solc.compile(JSON.stringify(input)));

  return {
    abi: contracts.contracts[contractName + ".sol"][contractName].abi,
    bytecode:
      contracts.contracts[contractName + ".sol"][contractName].evm.bytecode,
  };
}

module.exports = {
  compile,
};
