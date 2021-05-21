const fs = require('fs');
const { soliditySha3 } = require("web3-utils")

module.exports = async function(callback) {
  try {
    let rawdata = fs.readFileSync('whitelist.json');
    let whitelist = JSON.parse(rawdata);
    //console.log(whitelist);
    
    // Fetch accounts from wallet - these are unlocked
    const accounts = await web3.eth.getAccounts()

    let candidates = {}
    for (let i=0; i<whitelist.candidates.length; i++) {
      const hash = soliditySha3(whitelist.values[i], whitelist.candidates[i], '1622310400');
      const sig = await web3.eth.sign(hash, accounts[0])
      r1 = '0x' + sig.slice(2, 64+2)
      s1 = '0x' + sig.slice(64+2, 128+2)
      v1 = '0x' + sig.slice(128+2, 130+2)
      if (v1 == '0x00') {
        v1 = '0x1b'
      } 
      else if (v1 == '0x01') {
        v1 = '0x1c'
      }
      let candidate = {
        amount: whitelist.values[i],
        expiredAt: '1622310400',
        v: v1,
        r: r1,
        s: s1
      }
      candidates[whitelist.candidates[i]] = candidate
    }

    //console.log(candidates)
    let data = JSON.stringify(candidates);
    fs.writeFileSync('whitelist-signed.json', data);
    

  }
  catch(error) {
    console.log(error)
  }

  callback()
}