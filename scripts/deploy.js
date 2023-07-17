const fs = require("fs");
const colors = require("colors");
const { ethers } = require("hardhat");
async function main() {
  // get network
  let [owner] = await ethers.getSigners();
  console.log(owner.address);
  let network = await owner.provider._networkPromise;

  const LENDINGCONTRACT = await ethers.getContractFactory("Lending");
  var ledingContract = await LENDINGCONTRACT.deploy(
    "0x96E422C02149CBD21241F0E63da1f2E89371fDfc",
    "0x2C1b868d6596a18e32E61B901E4060C872647b6C",
    "0xf56dc6695cF1f5c364eDEbC7Dc7077ac9B586068",
    '0x0B3470B916cF46172940147B81941FD7B4ea2935'
  );
  await ledingContract.deployed();
  console.log("Lending contract",ledingContract.address);

  fs.writeFileSync(
    `./build/${network.chainId}.json`,
    JSON.stringify(ledingContract, undefined, 4)
  );
}

main()
  .then(() => {
    console.log("complete".green);
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
