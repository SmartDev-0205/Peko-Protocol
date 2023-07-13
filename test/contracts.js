const { expect } = require("chai");
const fs = require("fs");
const { ethers } = require("hardhat");
const { delay, fromBigNum, toBigNum } = require("./utils.js");

var owner;
var network;
var provider;

// var tokenContract;
// var presaleContract;

// var userWallet;

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

    wethContract = await ERC20TOKEN.deploy("WBNB TOKEN", "WBNB");
    await wethContract.deployed();

    const LendingContract = await ethers.getContractFactory("Lending");
    lendingContract = await LendingContract.deploy(
      pekoContract.address,
      wethContract.address,
      usdtContract.address
    );
  });
});

describe("contracts test", function () {
  it("send token to Contract", async () => {
    await pekoContract.transfer(lendingContract.address, toBigNum("1000", 18));
    let contractBalance = await pekoContract.balanceOf(lendingContract.address);
    await usdtContract.transfer(lendingContract.address, toBigNum("1000", 18));
    contractBalance = await usdtContract.balanceOf(lendingContract.address);
    var tx = await owner.sendTransaction({
      to: lendingContract.address,
      value: ethers.utils.parseUnits("100", 18),
    });
    await tx.wait();
  });

  // deposit eth and lend usdt

  //   it("Deposit", async () => {
  //     console.log("Deposit before lending balance",await provider.getBalance(lendingContract.address));
  //     var tx = await lendingContract.deposit(wethContract.address,toBigNum("1", 18),{ value: toBigNum("1", 18) });
  //     await tx.wait();
  //     console.log("Deposit after lending balance",await provider.getBalance(lendingContract.address));
  //   });

  //   it("Borrow", async () => {
  //     var tx = await lendingContract.borrow(usdtContract.address,toBigNum("400", 18));
  //     await tx.wait();
  //   });

  //   it("repay", async () => {
  //     var confirmTx = await usdtContract.approve(lendingContract.address,toBigNum("400", 18));
  //     await confirmTx.wait();
  //     var tx = await lendingContract.repay(usdtContract.address,toBigNum("400", 18));
  //     await tx.wait();
  //   });

  //   it("withdraw", async () => {
  //     var tx = await lendingContract.withdraw(wethContract.address,toBigNum("1", 18));
  //     await tx.wait();
  //   });

  //   it("liquidiate", async () => {
  //     var depositTx = await lendingContract.deposit(wethContract.address,toBigNum("1", 18),{ value: toBigNum("1", 18) });
  //     await depositTx.wait();
  //     var borrowTx = await lendingContract.borrow(usdtContract.address,toBigNum("400", 18));
  //     await borrowTx.wait();
  //     var confirmTx = await usdtContract.approve(lendingContract.address,toBigNum("400", 18));
  //     await confirmTx.wait();
  //     var tx = await lendingContract.liquidate(owner.address);
  //     await tx.wait();
  //   });

  //   it("Deposit", async () => {
  //     console.log("Deposit before lending balance",await provider.getBalance(lendingContract.address));
  //     var tx = await lendingContract.deposit(wethContract.address,toBigNum("1", 18),{ value: toBigNum("1", 18) });
  //     await tx.wait();
  //     console.log("Deposit after lending balance",await provider.getBalance(lendingContract.address));
  //   });

  //   it("Borrow", async () => {
  //     var tx = await lendingContract.borrow(usdtContract.address,toBigNum("400", 18));
  //     await tx.wait();
  //   });

  //   it("repay", async () => {
  //     var confirmTx = await usdtContract.approve(lendingContract.address,toBigNum("400", 18));
  //     await confirmTx.wait();
  //     var tx = await lendingContract.repay(usdtContract.address,toBigNum("400", 18));
  //     await tx.wait();
  //   });

  //   it("withdraw", async () => {
  //     var tx = await lendingContract.withdraw(wethContract.address,toBigNum("1", 18));
  //     await tx.wait();
  //   });

  //   it("liquidiate", async () => {
  //     var depositTx = await lendingContract.deposit(wethContract.address,toBigNum("1", 18),{ value: toBigNum("1", 18) });
  //     await depositTx.wait();
  //     var borrowTx = await lendingContract.borrow(usdtContract.address,toBigNum("400", 18));
  //     await borrowTx.wait();
  //     var confirmTx = await usdtContract.approve(lendingContract.address,toBigNum("400", 18));
  //     await confirmTx.wait();
  //     var tx = await lendingContract.liquidate(owner.address);
  //     await tx.wait();
  //   });

  //   it("Deposit", async () => {
  //     console.log("Deposit before lending balance",await provider.getBalance(lendingContract.address));
  //     var tx = await lendingContract.deposit(wethContract.address,toBigNum("1", 18),{ value: toBigNum("1", 18) });
  //     await tx.wait();
  //     console.log("Deposit after lending balance",await provider.getBalance(lendingContract.address));
  //   });

  //   it("Borrow", async () => {
  //     var tx = await lendingContract.borrow(usdtContract.address,toBigNum("400", 18));
  //     await tx.wait();
  //   });

  //   it("repay", async () => {
  //     var confirmTx = await usdtContract.approve(lendingContract.address,toBigNum("400", 18));
  //     await confirmTx.wait();
  //     var tx = await lendingContract.repay(usdtContract.address,toBigNum("400", 18));
  //     await tx.wait();
  //   });

  //   it("withdraw", async () => {
  //     var tx = await lendingContract.withdraw(wethContract.address,toBigNum("1", 18));
  //     await tx.wait();
  //   });

  //   it("liquidiate", async () => {
  //     var depositTx = await lendingContract.deposit(wethContract.address,toBigNum("1", 18),{ value: toBigNum("1", 18) });
  //     await depositTx.wait();
  //     var borrowTx = await lendingContract.borrow(usdtContract.address,toBigNum("400", 18));
  //     await borrowTx.wait();
  //     var confirmTx = await usdtContract.approve(lendingContract.address,toBigNum("400", 18));
  //     await confirmTx.wait();
  //     var tx = await lendingContract.liquidate(owner.address);
  //     await tx.wait();
  //   });

  // deposit usdt and borrow eth

  it("Deposit", async () => {
    console.log(
      "Deposit before lending balance",
      await provider.getBalance(lendingContract.address)
    );

    var confirmTx = await usdtContract.approve(
        lendingContract.address,
        toBigNum("1000", 18)
      );
    await confirmTx.wait();

    var tx = await lendingContract.deposit(
      usdtContract.address,
      toBigNum("1000", 18),
    );
    await tx.wait();
    console.log(
      "Deposit after lending balance",
      await provider.getBalance(lendingContract.address)
    );
  });

  it("Borrow", async () => {
    var tx = await lendingContract.borrow(
      wethContract.address,
      toBigNum("0.2", 18)
    );
    await tx.wait();
  });

//   it("repay", async () => {
//     var tx = await lendingContract.repay(
//       wethContract.address,
//       toBigNum("0.2", 18),
//       { value: toBigNum("0.2", 18) }
//     );
//     await tx.wait();
//   });

//   it("withdraw", async () => {
//     var tx = await lendingContract.withdraw(
//       usdtContract.address,
//       toBigNum("1000", 18)
//     );
//     await tx.wait();
//   });

  it("liquidiate", async () => {
    var tx = await lendingContract.liquidate(owner.address,{ value: toBigNum("0.2", 18) });
    await tx.wait();
  });
});