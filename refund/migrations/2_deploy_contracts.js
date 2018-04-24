var refund = artifacts.require("./refund.sol");


module.exports = function(deployer) {
  // Deploy the AirToken contract
	deployer.deploy(refund, web3.eth.accounts[0]);
};
