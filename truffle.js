const HDWalletProvider = require("truffle-hdwallet-provider");
const mnemonic = process.env.MNEMONIC;
const infuraApiToken = process.env.INFURA_API_TOKEN;
const index = process.env.INFURA_INDEX;

module.exports = {
  networks: {
    ropsten: {
      provider: () => new HDWalletProvider(
        mnemonic,
        `https://ropsten.infura.io/${infuraApiToken}`,
        index,
      ),
      network_id: 3,
      gas: 1500000,
    },
    rinkeby: {
      provider: () => new HDWalletProvider(
        mnemonic,
        `https://rinkeby.infura.io/${infuraApiToken}`,
        index,
      ),
      network_id: 4,
      gas: 1500000,
    },
    kovan: {
      provider: () => new HDWalletProvider(
        mnemonic,
        `https://kovan.infura.io/${infuraApiToken}`,
        index,
      ),
      network_id: 42,
      gas: 1500000,
    },
    local: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*", // Match any network id
      gas: 1500000,
    },
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 500,
    },
  },
};
