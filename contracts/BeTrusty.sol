// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Verifier.sol";

contract BeTrusty {
    AggregatorV3Interface internal dataFeed;
    IERC20 internal token;
    Verifier internal verifier;
    uint256 public immutable PRICE_PROOF_ONCHAIN = 20e18; // equivale a 20
    address public owner;

    // Mapping para almacenar que la prueba ya ha sido utilizada
    // Cuando el usuario decide hacer valida su "reputacion" on-chain
    // almacenamos aqui el secret generada en la primera ZKP
    mapping(uint256 => bool) public s_nullifierHash;

    struct Proof {
        uint[2] a;
        uint[2][2] b;
        uint[2] c;
    }

    // Scroll Seplia Address
    // ETH/USD 0x59F1ec1f10bD7eD9B938431086bC1D9e233ECf41
    // Verificar en : https://docs.chain.link/data-feeds/price-feeds/addresses?network=scroll&page=1
    constructor(address _verifier, address _token, address _feed) {
        dataFeed = AggregatorV3Interface(_feed);
        verifier = Verifier(_verifier);
        token = IERC20(_token);
        owner = msg.sender;
    }

    // Función para solo validar la prueba
    function verifyBeTrusty(
        Proof memory proof,
        uint[1] memory pubSignals
    ) external view returns (bool) {
        return verifier.verifyProof(proof.a, proof.b, proof.c, pubSignals);
    }

    // Función para solo validar la prueba
    function isProofNullified(
        uint[1] memory pubSignals
    ) external view returns (bool) {
        return s_nullifierHash[pubSignals[0]];
    }

    // Función para validar la prueba y registrarla on-chain
    // Se deben pagar 20 USD = PRICE_PROOF_ONCHAIN
    function verifyAndRegisterBeTrusty(
        Proof memory proof,
        uint[1] memory pubSignals
    ) external payable {
        require(!s_nullifierHash[pubSignals[0]], "Already nullified!");
        //uint256 requiredETH = calculateRequiredETH();
        require(msg.value >= calculateRequiredETH(), "Insufficient ETH sent");
        require(
            verifier.verifyProof(proof.a, proof.b, proof.c, pubSignals),
            "Proof invalid"
        );
        s_nullifierHash[pubSignals[0]] = true;
    }

    // Función para calcular la cantidad de ETH equivalente a 20 USD
    // segun el precio de Ethereum
    function calculateRequiredETH() public view returns (uint256) {
        int price = getChainlinkDataFeedLatestAnswer();
        require(price > 0, "Invalid price");
        uint256 adjustedPrice = uint256(price) * 10 ** 10; // Ajustar decimales del precio a 18
        uint256 amountInETH = (PRICE_PROOF_ONCHAIN * 10 ** 18) / adjustedPrice; // Cantidad en WEI
        return amountInETH;
    }

    // Convierte el valor en WEI devuelto en calculateRequiredETH()
    // a la cantidad en USDT que deberia dar siempre aprox 20 en 8 decimales
    function weiToUsd(uint256 _wei) public view returns (uint256) {
        return
            (_wei * uint256(getChainlinkDataFeedLatestAnswer())) / (10 ** 18); //
    }

    // Retorna el precio de ETH/USD
    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        (, int answer, , uint timeStamp, ) = dataFeed.latestRoundData();
        require(timeStamp > 0, "Round has not ended");
        return answer;
    }

    function undoNullified(uint[1] memory pubSignals) external onlyOwner {
        s_nullifierHash[pubSignals[0]] = false;
    }

    function updateVerifier(address _verifier) external onlyOwner {
        verifier = Verifier(_verifier);
    }

    function changeOwner(address _newOwner) external onlyOwner {
        owner = _newOwner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }
}
