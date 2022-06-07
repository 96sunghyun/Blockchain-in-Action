require("dotenv").config();
const express = require("express");
const app = express();
const Web3 = require("web3");
const HDWalletProvider = require("@truffle/hdwallet-provider");
const { abi } = require("./abi");
const port = 8080;
const { FROM_ADDRESS, RPC_PROVIDER, PRIVATE_KEY } = process.env;

const provider = new HDWalletProvider(PRIVATE_KEY, RPC_PROVIDER);
const web3 = new Web3(provider);
const address = "0x8522008984534D38a1Dd5F502fba93F403e0E7ed";

async function changeState() {
  try {
    console.log("in functions...");
    const myContract = new web3.eth.Contract(abi, address);
    const gasPrice = await web3.eth.getGasPrice();
    const recipient = await myContract.methods.changeState(2).send({
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

app.get("/change", (req, res) => {
  changeState().then((result) => {
    res.send(result);
  });
});

app.listen(port, () => {
  console.log("Listening...");
});
