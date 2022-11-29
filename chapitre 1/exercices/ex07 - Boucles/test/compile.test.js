const solc = require('solc');

function compile(contractName, content) {
    const input = {
        language: 'Solidity',
        sources: content,
        settings: {
            outputSelection: {
                '*': {
                    '*': ['*']
                }
            }
        }
    };

    const { contracts } = JSON.parse(solc.compile(JSON.stringify(input)));

    return {
        "abi": contracts[contractName + ".sol"][contractName].abi,
        "bytecode": contracts[contractName + ".sol"][contractName].evm.bytecode,
    };
}

module.exports = {
    compile,
}
