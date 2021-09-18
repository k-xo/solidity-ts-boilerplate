require('dotenv').config()
import { HardhatUserConfig } from 'hardhat/config'
import '@nomiclabs/hardhat-waffle'

const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY
const ROPSTEN_PRIVATE_KEY = process.env.ROPSTEN_PRIVATE_KEY

const config: HardhatUserConfig = {
  solidity: '0.8.4',
  networks: {
    ropsten: {
      url: `https://eth-ropsten.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [`0x${ROPSTEN_PRIVATE_KEY}`],
    },
  },
}

export default config
