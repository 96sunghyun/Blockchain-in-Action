require("dotenv").config();
const { abi } = require("./abi");
const { bin } = require("./binary");
const Web3 = require("web3");
const express = require("express");
const HDWalletProvider = require("@truffle/hdwallet-provider");
const { FROM_ADDRESS, PRIVATE_KEY, RPC_PROVIDER } = process.env;
const port = 8080;

const app = express();
const provider = new HDWalletProvider(PRIVATE_KEY, RPC_PROVIDER);
const web3 = new Web3(provider);

async function deployToken() {
  try {
    console.log("deploying...");
    const myContract = new web3.eth.Contract(abi);
    const gasPrice = await web3.eth.getGasPrice();
    const recipient = await myContract.deploy({ data: "0x" + bin }).send({
      from: FROM_ADDRESS,
      gas: 2000000,
      gasPrice,
    });
    console.log(recipient);
    return recipient;
  } catch (e) {
    console.log(e);
    return e;
  }
}

app.get("/deployToken", (req, res) => {
  deployToken().then((result) => {
    res.send(result._address);
  });
});

app.listen(port, (_) => {
  console.log("Listening...");
});
