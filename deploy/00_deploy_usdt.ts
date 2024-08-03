import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";
import { ethers } from "ethers";

/**
 * Deploys a contract named "YourContract" using the deployer account and
 * constructor arguments set to the deployer address
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployYourContract: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  await deploy("MockUSDT", {
    from: deployer,        
    log: true,  
    gasLimit: "5000000",      
    //gasPrice: ethers.parseUnits("0.001", "ether").toString(),    
    
  });

  // Get the deployed contract to interact with it after deploying.
  const usdt = await hre.ethers.getContract<Contract>("MockUSDT", deployer);
  console.log("👋 Balance Of:", await usdt.balanceOf(deployer));
};

export default deployYourContract;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags YourContract
deployYourContract.tags = ["MockUSDT"];