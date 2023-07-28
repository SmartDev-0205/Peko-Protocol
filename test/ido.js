const { expect } = require("chai");
const fs = require("fs");
const { ethers } = require("hardhat");
const { delay, fromBigNum, toBigNum } = require("./utils.js");
const { mine } = require("@nomicfoundation/hardhat-network-helpers");

var owner;
var idoContract;
var pekoContract;

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
    await idoContract.deployed();
  });
});

describe("contracts test", function () {
  it("send token to Contract", async () => {
    await pekoContract.transfer(idoContract.address, toBigNum("100000000", 6));
  });

  it("set private sale", async () => {
    var tx = await idoContract.startSale(1);
    await tx.wait();
    var currentPrice = await idoContract.getPrice();
    console.log("Current Price after start private sale ", currentPrice);
  });

  it("buy token with 0.1 eth and 9 eth", async () => {
    var tx = await idoContract.addToWhitelist([owner.address]);
    await tx.wait();

    var tx = await idoContract.buy({ value: toBigNum("0.2", 18) });
    await tx.wait();

    var claimAmount = await idoContract.getClaimAmount(owner.address);
    console.log("Claim amount after buy 0.2 eth ", claimAmount);

    
    var tx = await idoContract.buy({ value: toBigNum("9.8", 18) });
    await tx.wait();

    var claimAmount = await idoContract.getClaimAmount(owner.address);
    console.log("Claim amount after buy 9 eth ", claimAmount);

    var currentPrice = await idoContract.getPrice();
    console.log("Current Price ", currentPrice);

    var tx = await idoContract.claimRewardToken();
    await tx.wait();
  });

  it("set public sale", async () => {
    var tx = await idoContract.startSale(2);
    await tx.wait();
    var currentPrice = await idoContract.getPrice();
    console.log("Current Price after start public sale ", currentPrice);
  });

  it("buy token with 0.1 eth and 10 eth", async () => {
    var tx = await idoContract.addToWhitelist([owner.address]);
    await tx.wait();

    var tx = await idoContract.buy({ value: toBigNum("0.2", 18) });
    await tx.wait();

    var claimAmount = await idoContract.getClaimAmount(owner.address);
    console.log("Claim amount after buy 0.2 eth ", claimAmount);


    var tx = await idoContract.publicSaleBuy();
    await tx.wait();

    var tx = await idoContract.buy({ value: toBigNum("10", 18) });
    await tx.wait();

    var claimAmount = await idoContract.getClaimAmount(owner.address);
    console.log("Claim amount after buy 10 eth ", claimAmount);
    

    var currentPrice = await idoContract.getPrice();
    console.log("Current Price ", currentPrice);

    var tx = await idoContract.claimRewardToken();
    await tx.wait();
  });
});
