# BeTrusty - Smart Contracts

En este repositorio están los smart contracts del protocolo.

## Despliegue de contratos

```shell
npx hardhat deploy
```

Para desplegar en Scroll Sepolia

```shell
npx hardhat deploy --network scrollSepolia
```

## Verificar contratos

Verificar contrato `BeTrusty`

```shell
npx hardhat verify --network scrollSepolia ADDRESS_DEL_CONTRATO_BE_TRUSTY PRIMER_PARAMETRO_CONSTRUCTOR SEGUNDO_PARAMETRO_CONSTRUCTOR
```
Verificar contrato `Verifier`

```shell
npx hardhat verify --network scrollSepolia ADDRESS_DEL_CONTRATO_VERIFIER
```

## Actualización del Verifier

Se deve actualizar el address del `verifier` en el contrato `BeTrusty` ejecutando la función `updateVerifier`.

## Addresses de los contratos

| Contrato   | Dirección                                    |
|------------|----------------------------------------------|
| BeTrusty   | `0x48007bd1C17649F53D9D13ad57E8dDCd958135Dd` |
| Verifier   | `0xA39e0B1Ac857596Ca04c06543AA8449504E3051a` |


