const fs = require('fs');
const { compile } = require('./compile.test');

const ganache = require('ganache-cli');
const provider = ganache.provider();
const Web3 = require('web3');
const web3 = new Web3(provider);

const mocha = require('mocha');
const assert = require('assert');

mocha.describe('Variables', () => {
    const contractName = 'Variables';
    let accounts = undefined;
    let contract = undefined;

    mocha.beforeEach(async () => {
        const { abi, bytecode } = compile(contractName, {
            'Variables.sol': {
                content: fs.readFileSync('./exercices/ex02 - Variables/sources/' + contractName + ".sol", "utf-8")
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
    mocha.it('all variables are good', async () => {
        const answerToLife = await contract.methods.answerToLife().call();
        const wrongAnswerToLife = await contract.methods.wrongAnswerToLife().call();
        const sentence = await contract.methods.sentence().call();
        const isTrue = await contract.methods.isTrue().call();
        const address = await contract.methods.owner().call();

        const account = await web3.eth.getAccounts();

        assert.equal(answerToLife, 42);
        assert.equal(wrongAnswerToLife, -42);
        assert.equal(sentence, "I'm a string");
        assert.equal(isTrue, true);
        assert.equal(address, account[0]);
    });
});
