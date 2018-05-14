var msig = artifacts.require("./ZperMultiSigWallet.sol");


module.exports = function(deployer) {

  deployer.deploy(msig, web3.eth.accounts, 2);
};
