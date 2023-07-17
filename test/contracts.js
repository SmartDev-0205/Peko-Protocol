const { expect } = require("chai");
const fs = require("fs");
const { ethers } = require("hardhat");
const { delay, fromBigNum, toBigNum } = require("./utils.js");
const { mine } = require("@nomicfoundation/hardhat-network-helpers");

var owner;
var network;
var provider;

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
      usdtContract.address,
      "0x0B3470B916cF46172940147B81941FD7B4ea2935"
    );
  });
});

describe("contracts test", function () {
  it("send token to Contract", async () => {
    await pekoContract.transfer(
      lendingContract.address,
      toBigNum("100000", 18)
    );
    let contractBalance = await pekoContract.balanceOf(lendingContract.address);
    await usdtContract.transfer(
      lendingContract.address,
      toBigNum("100000", 18)
    );
    contractBalance = await usdtContract.balanceOf(lendingContract.address);
    var tx = await owner.sendTransaction({
      to: lendingContract.address,
      value: ethers.utils.parseUnits("100", 18),
    });
    await tx.wait();
  });

  it("Contract test", async () => {

    // init platform
    // 10 *decimal/(31,536,000 *100) = 30 so 1% = 317, 1% meaning 100 so decimal  = 1e14
    // var tx = lendingContract.addPool(ethAddress, 80, 50, 100, 0, 0);
    // await tx.wait();
    // // 10 *decimal/(31,536,000 *100)
    // var tx = lendingContract.addPool(usdtAddress, 80, 50, 100, 0, 0);
    // await tx.wait();
    // var tx = lendingContract.setBorrowApy(100, 70, 500, 2600);
    // await tx.wait();
    // var tx = lendingContract.setSupplyApy(50, 70, 300, 2000);
    // await tx.wait();

    

    // 1000$ deposit
    var confirmTx = await usdtContract.approve(
      lendingContract.address,
      toBigNum("100000000", 6)
    );
    await confirmTx.wait();

    var tx = await lendingContract.deposit(
      usdtContract.address,
      toBigNum("100000000", 6)
    );
    await tx.wait();
    var tx = await lendingContract.deposit(
      wethContract.address,
      toBigNum("1", 18),
      {
        value: toBigNum("1", 18),
      }
    );
    await tx.wait();
    await mine(31_536_000);

    var tx = await lendingContract.withdraw(
      usdtContract.address,
      toBigNum("10000000", 6)
    );
    await tx.wait();

    var userinfo = await lendingContract.getUserInfo(owner.address);
    console.log("delay user info ", userinfo);

    var tx = await lendingContract.borrow(
      wethContract.address,
      toBigNum("0.4", 18)
    );
    await tx.wait();

    // var tx = await lendingContract.borrow(
    //   usdtContract.address,
    //   toBigNum("60000000", 6)
    // );
    // await tx.wait();

    // var tx = await lendingContract.borrow(
    //   usdtContract.address,
    //   toBigNum("200", 6)
    // );
    // await tx.wait();

    // await mine(10000000);

    // var tx = await lendingContract.repay(
    //   wethContract.address,
    //   toBigNum("0.1", 18),
    //   { value: toBigNum("0.1", 18) }
    // );
    // await tx.wait();

    // var confirmTx = await usdtContract.approve(
    //   lendingContract.address,
    //   toBigNum("10000000", 18)
    // );
    // await confirmTx.wait();
    // var tx = await lendingContract.repay(
    //   usdtContract.address,
    //   toBigNum("10000000", 18)
    // );
    // await tx.wait();

    // var userinfo = await lendingContract.getUserInfo(owner.address);
    // console.log("user info ", userinfo);

    // var confirmTx = await usdtContract.approve(
    //   lendingContract.address,
    //   userinfo.usdtBorrowAmount.add(userinfo.usdtInterestAmount)
    // );
    // await confirmTx.wait();

    // var tx = await lendingContract.liquidate(owner.address, {
    //   value: userinfo.ethBorrowAmount.add(userinfo.ethInterestAmount),
    // });


    // var userinfo = await lendingContract.getUserInfo(owner.address);
    // console.log("user info ", userinfo);

    var poolinfo = await lendingContract.getPoolInfo(usdtContract.address);
    console.log("pool info ", poolinfo);

    var listpools = await lendingContract.listPools();
    console.log("listPools ", listpools);

    // // var userinfo = await lendingContract.getUserInfo(owner.address);
    // // console.log("after user info ", userinfo);

    // var ethPool = await lendingContract.getPoolInfo(wethContract.address);
    // console.log("pool info ", ethPool);

    // var tx = await lendingContract.withdraw(
    //   usdtContract.address,
    //   toBigNum("200", 6)
    // );

    // var userinfo = await lendingContract.getUserInfo(owner.address);
    // console.log("user info ", userinfo);

    // var confirmTx = await usdtContract.approve(
    //   lendingContract.address,
    //   userinfo.usdtBorrowAmount.add(userinfo.usdtInterestAmount)
    // );
    // await confirmTx.wait();

    // var tx = await lendingContract.liquidate(owner.address, {
    //   value: userinfo.ethBorrowAmount.add(userinfo.ethInterestAmount),
    // });

    // var marketInfo = await lendingContract.getMarketInfo();
    // console.log("market info ", marketInfo);

    // var userinfo = await lendingContract.getPoolInfo(usdtContract.address);
    // console.log("pool info ", userinfo);

    // get userinfo from ownder
    // for(let i = 0;i <10000000000;i++){}
    // var userinfo = await lendingContract.getUserInfo(owner.address);
    // console.log("delay user info ", userinfo);
    // var addr1userinfo = await lendingContract.(addr1.address);
    // console.log("delay addr1user info ", addr1userinfo);

    // list users
    // var userlist = await lendingContract.listUserInfo();
    // var tx = await lendingContract.withdraw(
    //   usdtContract.address,
    //   toBigNum("1000", 6)
    // );
    // await tx.wait();

    // var tx = await lendingContract.borrow(
    //   wethContract.address,
    //   toBigNum("0.4", 18)
    // );
    // await tx.wait();

    // var tx = await lendingContract.borrow(usdtContract.address,toBigNum("400", 6));
    // await tx.wait();

    // var tx = await lendingContract.repay(
    //   wethContract.address,
    //   toBigNum("0.1", 18),
    //   { value: toBigNum("0.1", 18) }
    // );
    // await tx.wait();

    // var userinfo = await lendingContract.getUserInfo(owner.address);
    // console.log("user info ", userinfo);

    // var confirmTx = await usdtContract.approve(
    //   lendingContract.address,
    //   userinfo.usdtBorrowAmount.add(userinfo.usdtInterestAmount)
    // );
    // await confirmTx.wait();

    // var tx = await lendingContract.liquidate(owner.address, {
    //   value: userinfo.ethBorrowAmount.add(userinfo.ethInterestAmount),
    // });

    // var listpools = await lendingContract.listPools();
    // console.log("listPools ", listpools);

    // var liquidationThreshhold = await lendingContract.getLiquidationThreshhold();
    // console.log("getLiquidationThreshhold ", liquidationThreshhold);

    // var userinfo = await lendingContract.getPoolInfo(wethContract.address);
    // console.log("user info ", userinfo);

    // await tx.wait();
    // var currentMarket = await lendingContract.getMarketInfo();
    // console.log("Current market price", currentMarket);
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

  //   it("Deposit", async () => {
  //     console.log(
  //       "Deposit before lending balance",
  //       await provider.getBalance(lendingContract.address)
  //     );

  //     var confirmTx = await usdtContract.approve(
  //         lendingContract.address,
  //         toBigNum("1000", 18)
  //       );
  //     await confirmTx.wait();

  //     var tx = await lendingContract.deposit(
  //       usdtContract.address,
  //       toBigNum("1000", 18),
  //     );
  //     await tx.wait();
  //     console.log(
  //       "Deposit after lending balance",
  //       await provider.getBalance(lendingContract.address)
  //     );
  //   });

  //   it("Borrow", async () => {
  //     var tx = await lendingContract.borrow(
  //       wethContract.address,
  //       toBigNum("0.2", 18)
  //     );
  //     await tx.wait();
  //   });

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

  //   it("liquidiate", async () => {
  //     var tx = await lendingContract.liquidate(owner.address,{ value: toBigNum("0.2", 18) });
  //     await tx.wait();
  //   });
});
