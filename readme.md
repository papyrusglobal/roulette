Casino roulette game on smart contract and ERC20 token
======================================================

Provably fair roulette game implemented as an Ethereum smart contract.

Random value is taken from 3 hashes of blocks following the the block where
the bet was made. Such a value is uniformly distributed, that was tested with
[eth-collect-data](https://github.com/denisglotov/exp/tree/master/eth-collect-data)
code.

Frontend is minimal here (I am not a frontend developer, thus not included
here) and works with the Ethereum blockchain using [Metamask][] browser
extension.

The roulette contract is ERC20 token. Tokens are mined when the contract
cannot return win to the player, so she can cash them later, when the contract
earns enough ether for the payment.

To deploy, flatten the contract (if you want to use remix):

        npm run -s flatten contracts/Roulette.sol >Roulette.flattened.sol

[Metamask]: https://metamask.io
