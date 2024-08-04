import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";
import { ethers } from "ethers";

const deployVerifier: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  await deploy("Verifier", {
    from: deployer,        
    log: true,      
  });

  // Get the deployed contract to interact with it after deploying.
  const verifier = await hre.ethers.getContract<Contract>("Verifier", deployer);
  console.log("👋 Verifier deployed:", await verifier.getAddress());
};

export default deployVerifier;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags YourContract
deployVerifier.tags = ["Verifier"];