var ZperToken = artifacts.require("./ZperToken.sol");


module.exports = function(deployer) {

	deployer.deploy(ZperToken, web3.eth.accounts[0], 2200000000, 3500000000);
};
