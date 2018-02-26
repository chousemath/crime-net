var Case = artifacts.require('Case');
module.exports = function(deployer) {
  deployer.deploy(Case).then(function() {
    console.log('contract address:', Case.address);
  });
}