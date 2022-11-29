const fs = require('fs');
const { compile } = require('./compile.test');

const ganache = require('ganache-cli');
const provider = ganache.provider();
const Web3 = require('web3');
const web3 = new Web3(provider);

const mocha = require('mocha');
const assert = require('assert');

mocha.describe('Array', () => {
    const contractName = 'Array';
    let accounts = undefined;
    let contract = undefined;

    mocha.beforeEach(async () => {
        const { abi, bytecode } = compile(contractName, {
            'Array.sol': {
                content: fs.readFileSync('./exercices/ex05 - Arrays/sources/' + contractName + ".sol", "utf-8")
            }
        });
        accounts = await web3.eth.getAccounts();
        contract = await new web3.eth.Contract(abi)
            .deploy({data: bytecode.object.toString()})
            .send({from: accounts[0], gas: 3000000});
    });
    mocha.it('has been deployed', () => {
        assert.ok(contract.options.address);
    });
    mocha.it('the functions and array works good', async () => {
        await contract.methods.set(0, 5).send({from: accounts[0], gas: 3000000});
        await contract.methods.set(1, 6).send({from: accounts[0], gas: 3000000});
        await contract.methods.set(2, 7).send({from: accounts[0], gas: 3000000});

        const first = await contract.methods.get(0).call();
        const second = await contract.methods.get(1).call();
        const third = await contract.methods.get(2).call();
        assert.equal(first, 5);
        assert.equal(second, 6);
        assert.equal(third, 7);
    });
});
