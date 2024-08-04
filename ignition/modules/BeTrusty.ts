import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
//import { parseEther } from "viem";

const BeTrustyModule = buildModule("BeTrustyModule", (m) => {

  const addressVerifier = "0x59F1ec1f10bD7eD9B938431086bC1D9e233ECf41"
  const priceFeedAddress = "0x59F1ec1f10bD7eD9B938431086bC1D9e233ECf41"

  const betrusty = m.contract("BeTrusty");

  return { betrusty };
});

export default BeTrustyModule;
