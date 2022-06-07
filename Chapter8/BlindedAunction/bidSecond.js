require("dotenv").config();
const { abi } = require("./abi");
const express = require("express");
const app = express();
const HDWalletProvider = require("@truffle/hdwallet-provider");
const { SECOND_ADDRESS, SECOND_PRIVATE, RPC_PROVIDER } = process.env;
const Web3 = require("web3");
const port = 8080;

const provider = new HDWalletProvider(SECOND_PRIVATE, RPC_PROVIDER);
const web3 = new Web3(provider);
const address = "0x8522008984534D38a1Dd5F502fba93F403e0E7ed";

// console.log(web3.utils.soliditySha3(2, "salt"));

async function bid() {
  try {
    console.log("bidding......");
    const myContract = new web3.eth.Contract(abi, address);
    const gasPrice = await web3.eth.getGasPrice();
    const blindedValue = await web3.utils.soliditySha3(2, "salt");
    const recipient = await myContract.methods.bid(blindedValue).send({
      from: SECOND_ADDRESS,
      value: 2000000,
      gas: 2000000,
      gasPrice,
    });

    return recipient;
  } catch (e) {
    console.log(e);
    return e;
  }
}

app.get("/secondBid", (req, res) => {
  bid().then((result) => {
    console.log(result);
  });
});

app.listen(port, () => {
  console.log("Listening...");
});
