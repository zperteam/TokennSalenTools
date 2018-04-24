var ZperMainSale = artifacts.require("./ZperMainSale.sol");


module.exports = function(deployer) {

  const startTime = 1523587006; 				// 2018.3.17. 2pm KST
  const endTime = startTime + (60 * 20);	// for twenty minutes
  const hardCap = 20000;

  deployer.deploy(ZperMainSale, web3.eth.coinbase, startTime, endTime, hardCap);
};
