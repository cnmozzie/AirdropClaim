const AirdropClaim = artifacts.require("AirdropClaim");

module.exports = function(deployer) {
  deployer.deploy(AirdropClaim, '0x5aa1a18432aa60bad7f3057d71d3774f56cd34b8'); //change the address before migrating to mainnet
};
