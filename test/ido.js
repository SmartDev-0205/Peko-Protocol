const { expect } = require("chai");
const fs = require("fs");
const { ethers } = require("hardhat");
const { delay, fromBigNum, toBigNum } = require("./utils.js");
const { mine } = require("@nomicfoundation/hardhat-network-helpers");

var owner;

describe("deploy contracts", function () {
  it("Create account", async function () {
    [owner, addr1, addr2] = await ethers.getSigners();
    provider = ethers.provider;
    var tx = await owner.sendTransaction({
      to: addr1.address,
      value: ethers.utils.parseUnits("100", 18),
    });
    await tx.wait();
  });
  

  it("deploy contracts", async function () {
    //QE token deployment
    const ERC20TOKEN = await ethers.getContractFactory("NormalToken");
    pekoContract = await ERC20TOKEN.deploy("PEKO REWARD", "PEKO");
    await pekoContract.deployed();

    usdtContract = await ERC20TOKEN.deploy("USD STABLE", "USDT");
    await usdtContract.deployed();

    const IDOContract = await ethers.getContractFactory("IDO");
    idoContract = await IDOContract.deploy(
      pekoContract.address,
      usdtContract.address
    );
  });
});

describe("contracts test", function () {
  it("send token to Contract", async () => {
    await pekoContract.transfer(
      idoContract.address,
      toBigNum("1000000000", 18)
    );
  });

  it("Contract test", async () => {
    var confirmTx = await usdtContract.approve(
      idoContract.address,
      toBigNum("1000000000", 6)
    );
    await confirmTx.wait();

    var tx = await idoContract.buyWithUSDT(toBigNum("1000", 6));
    await tx.wait();

    var currentPrice = await idoContract.getPrice();
    console.log("Current Price ", currentPrice);

    // var tx = await idoContract.buyWithUSDT(toBigNum("200000", 6));
    // await tx.wait();

    // var tx = await idoContract.buyWithUSDT(toBigNum("200000", 6));
    // await tx.wait();

    // var tx = await idoContract.buyWithUSDT(toBigNum("200000", 6));
    // await tx.wait();

    var claimAmount = await idoContract.getClaimAmount(owner.address);
    console.log("Claim amount ", claimAmount);

    var currentPrice = await idoContract.getPrice();
    console.log("Current Price ", currentPrice);

    var tx = await idoContract.claimRewardToken();
    await tx.wait();

  });
});
