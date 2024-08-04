import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

const deployBeTrusty: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  const addressVerifier = "0x59F1ec1f10bD7eD9B938431086bC1D9e233ECf41"
  const priceFeedAddress = "0x59F1ec1f10bD7eD9B938431086bC1D9e233ECf41"
  
  await deploy("BeTrusty", {
    from: deployer,        
    log: true,  
    args: [addressVerifier, priceFeedAddress],     
  });

  // Get the deployed contract to interact with it after deploying.
  const betrusty = await hre.ethers.getContract<Contract>("BeTrusty", deployer);
  console.log("👋 Contract BeTrusty deployed:", await betrusty.getAddress());
};

export default deployBeTrusty;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags YourContract
deployBeTrusty.tags = ["BeTrusty"];