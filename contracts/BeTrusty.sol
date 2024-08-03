// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Verifier.sol";

contract BeTrusty {
    AggregatorV3Interface internal dataFeed;
    IERC20 internal token;
    Verifier internal verifier;
    //uint256 public immutable PRICE_PROOF_ONCHAIN = 20 * 10**6; // Decimales de USDT
    uint256 public immutable PRICE_PROOF_ONCHAIN = 0.0001 ether; // Decimales de USDT
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
    constructor(address _verifier, address _token) {
        dataFeed = AggregatorV3Interface(
            0x59F1ec1f10bD7eD9B938431086bC1D9e233ECf41
        );
        verifier = Verifier(_verifier);
        token = IERC20(_token);
    }

    // Función para solo validar la prueba
    function verifyBeTrusty(        
        Proof memory proof,
        uint[1] memory pubSignals
    ) external view returns(bool){
        return verifier.verifyProof(proof.a, proof.b, proof.c, pubSignals);
    }
    // Función para validar la prueba y registrarla on-chain 
    // Se deben pagar 20 USD = PRICE_PROOF_ONCHAIN
    function verifyAndRegisterBeTrusty(        
        Proof memory proof,
        uint[1] memory pubSignals
    ) external payable {
        require(!s_nullifierHash[pubSignals[0]], "Already nullified!");
        uint256 requiredETH = calculateRequiredETH();
        require(msg.value >= requiredETH, "Insufficient ETH sent");
        require(verifier.verifyProof(proof.a, proof.b, proof.c, pubSignals), "Proof invalid");
    }

    // Función para calcular la cantidad de ETH equivalente a 20 USD
    function calculateRequiredETH() public view returns (uint256) {
        int price = 296518760000;//getChainlinkDataFeedLatestAnswer();
        require(price > 0, "Invalid price");
        uint256 adjustedPrice = uint256(price) * 10**10; // Ajustar decimales del precio a 18
        uint256 amountInETH = (PRICE_PROOF_ONCHAIN * 10**18) / adjustedPrice; // Cantidad en WEI
        return amountInETH;
    }

    // Función para validar que se ha enviado la cantidad correcta de ETH
    function validatePayment() external payable {
        uint256 requiredETH = calculateRequiredETH();
        require(msg.value >= requiredETH, "Insufficient ETH sent");
    }
    
    /**
     * Returns the latest answer.
     */
    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        ( ,int answer, ,uint timeStamp, ) = dataFeed.latestRoundData();
        require(timeStamp > 0, "Round has not ended");
        return answer;
    }
}
