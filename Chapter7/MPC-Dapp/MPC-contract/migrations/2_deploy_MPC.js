const MPC = artifacts.require("MPC");

module.exports = function (deployer) {
  deployer.deploy(MPC, "0x5A603e4c468436112C00bCD8c782A0aD980ab43A");
};
