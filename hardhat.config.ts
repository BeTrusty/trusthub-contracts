import type { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";
import "@nomicfoundation/hardhat-verify";
import "hardhat-deploy"
import "hardhat-deploy-ethers";

require('dotenv').config()

const providerApiKey = process.env.ALCHEMY_API_KEY
const deployerPrivateKey = process.env.DEPLOYER_PRIVATE_KEY || ""
const etherscanApiKey = process.env.ETHERSCAN_API_KEY || "" // No la utilizamos para scroll sepolia
const urlRPC = "https://scroll-testnet-public.unifra.io"


const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    scrollSepolia: {
      gasPrice: 700000000,
      url: urlRPC,
      accounts: [deployerPrivateKey]
    }
  },
  namedAccounts: {
    deployer: {
      default: 0
    }
  },

  etherscan: {
    apiKey: {
      mainnet: etherscanApiKey,
      scrollSepolia: etherscanApiKey
    },    
    customChains: [
      {
        network: 'scrollSepolia',
        chainId: 534351,
        urls: {
          apiURL: 'https://api-sepolia.scrollscan.com/api',
          browserURL: 'https://sepolia.scrollscan.com/'
        },
      }
    ],    
  },
  sourcify: {
    enabled: false,
    apiUrl: 'https://api-sepolia.scrollscan.com/api',
    browserUrl: 'https://sepolia.scrollscan.com/'
  }
};

export default config;
