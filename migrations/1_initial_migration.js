var Migrations = artifacts.require("PunchCardNFT");

module.exports = function(deployer) {
  deployer.deploy(Migrations, {gas:4000000});
};
