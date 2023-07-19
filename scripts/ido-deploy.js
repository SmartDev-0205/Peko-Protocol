const fs = require("fs");
const colors = require("colors");
const { ethers } = require("hardhat");
async function main() {
  // get network
  let [owner] = await ethers.getSigners();
  console.log(owner.address);
  let network = await owner.provider._networkPromise;

  const IDOCONTRACT = await ethers.getContractFactory("IDO");
  var ledingContract = await IDOCONTRACT.deploy(
    "0x96E422C02149CBD21241F0E63da1f2E89371fDfc",
    "0xf56dc6695cF1f5c364eDEbC7Dc7077ac9B586068"
  );
  await ledingContract.deployed();
  console.log("IDO contract", ledingContract.address);

  const Erc20Contract = await ethers.getContractFactory("ERC20");
  const erc20Contract = Erc20Contract.attach(
    "0x96E422C02149CBD21241F0E63da1f2E89371fDfc"
  );
  await erc20Contract.transfer(IDOCONTRACT.address,"100000000000000000000000000");

//   await owner.sendTransaction({
//     to: contractAddress,
//     value: ethers.utils.parseEther("0.1"), // Sends exactly 1.0 ether
//   });

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
