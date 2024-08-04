const { ethers } = require("ethers");

// Configuración de la conexión a la blockchain
const provider = new ethers.JsonRpcProvider("https://rpc.ankr.com/scroll_sepolia_testnet");

// Dirección del contrato del token ERC20 y la dirección del usuario
const tokenAddress = "0x4dB3cA95421492855bE5c030Db297e399d8da968";
const walletAddress = "0xa08A9F51475B42d8F15b28bD91918221Ee71bf8F";

// ABI mínimo necesario para interactuar con el contrato ERC20
const abi = [
  {
    "constant": true,
    "inputs": [{"name":"owner","type":"address"}],
    "name": "balanceOf",
    "outputs": [{"name":"","type":"uint256"}],
    "type": "function"
  }
];

// Crear una instancia del contrato
const contract = new ethers.Contract(tokenAddress, abi, provider);

async function getBalance() {
  try {
    // Consultar el balance
    const balance = await contract.balanceOf(walletAddress);
    console.log(`Balance: ${ethers.formatUnits(balance, 6)} tokens`);
  } catch (error) {
    console.error("Error al consultar el balance:", error);
  }
}

getBalance();
