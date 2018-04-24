var ZperPreSale = artifacts.require("./ZperPreSale.sol");


module.exports = function(deployer) {

  const startTime = 1521262800; 				// 2018.3.17. 2pm KST
  const endTime = startTime + (60 * 60 * 3);	// for three hours
  const hardCap = 20000;

  deployer.deploy(ZperPreSale, web3.eth.coinbase, startTime, endTime, hardCap);
};
