const fs = require("fs");
const colors = require("colors");
const { ethers } = require("hardhat");
async function main() {
  // get network
  let [owner] = await ethers.getSigners();
  console.log(owner.address);
  let network = await owner.provider._networkPromise;
  
  console.log("IDO contract", idoContract.address);
  await tokenContract.transfer(idoContract.address, "40000000000000");

  // deployment result
  var contractObject = {
    token: {
      address: tokenContract.address,
    },
    IDO: {
      address: idoContract.address,
    },
  };

  fs.writeFileSync(
    `./build/IDO_${network.chainId}.json`,
    JSON.stringify(contractObject, undefined, 4)
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
