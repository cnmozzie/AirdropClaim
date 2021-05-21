# AirdropClaim
Airdrop Claim Smart Contract for LOWB

### Compiling and running the code
- Before running this project, install truffle first: `npm install -g truffle`.

- Run `npm install` to install required modules.

- Compile the smart contracts: `truffle compile`.

- Deploy to local network: `truffle migrate`. (You may need to start [Ganache](https://www.trufflesuite.com/ganache) before migrating.)

- Edit the `whitelist.json`, then sign it: `truffle exec sign.js`.

- Now you can start to play with this contract: `truffle console`. For example, you can claim your tokens by:

  ```javascript
  truffle(development)> let instance = await AirdropClaim.deployed()
  truffle(development)> let whitelist = require('./whitelist-signed.json')
  truffle(development)> const accounts = await web3.eth.getAccounts()
  truffle(development)> let me = whitelist[accounts[0]]
  truffle(development)> instance.claim(me.amount, me.expiredAt, me.v, me.r, me.s)
  ```
### Depolying to the live network

- Change the token address in `2_deploy_contracts.js` before deploying to live work.
- Create a new .secret file in root directory and enter your 12 word mnemonic seed phrase. Then just run `truffle migrate --network testnet`. You will deploy contracts to the Binance testnet. (To sign the whitelist by your accounts on testnet, run `truffle exec sign.js --network testnet`.)
- To verify the contract, create a new .apikey file in root directory and enter the [API Key](https://bscscan.com/myapikey). Then just run `truffle run verify AirdropClaim@{contract-address} --network testnet`. 

