import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
//import { parseEther } from "viem";

const MockUSDTModule = buildModule("MockUSDTModule", (m) => {
  const mockUSDT = m.contract("MockUSDT");

  return { mockUSDT };
});

export default MockUSDTModule;
