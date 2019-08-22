const TestRoulette = artifacts.require("./TestRoulette.sol");
const Roulette = artifacts.require("./Roulette.sol");

module.exports = function(deployer, network) {
  if (network === 'test') {
    deployer.deploy(TestRoulette);
  } else {
    deployer.deploy(Roulette);
  }
};
