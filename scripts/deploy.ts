import { ethers, run } from 'hardhat'

async function main() {
  await run('compile')

  const Flashloan = await ethers.getContractFactory('AaveFlashLoan')
  const flashloan = await Flashloan.deploy('0x1c8756FD2B28e9426CDBDcC7E3c4d64fa9A54728') //ropsten

  await flashloan.deployed()

  console.log('flashloan deployed to:', flashloan.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
