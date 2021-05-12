const Master = artifacts.require("Master");
const HORS = artifacts.require("HORS");

module.exports = async function (deployer) {
  await deployer.deploy(Master);
  await deployer.deploy(HORS, Master.address);
};
