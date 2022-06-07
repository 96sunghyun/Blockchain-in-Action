require("dotenv").config();
const { abi } = require("./abi");
const { bin } = require("./binary");
const express = require("express");
const Web3 = require("web3");
const app = express();
const port = 8080;
const HDWalletProvider = require("@truffle/hdwallet-provider");

const { RPC_PROVIDER, PRIVATE_KEY, FROM_ADDRESS, TO_ADDRESS, MNEMONIC_CODE } =
  process.env;

const provider = new HDWalletProvider(PRIVATE_KEY, RPC_PROVIDER);
const web3 = new Web3(provider);

async function deploy() {
  try {
    const myContract = new web3.eth.Contract(abi);
    const gasPrice = await web3.eth.getGasPrice();
    const recipient = await myContract
      .deploy({
        data: "0x" + bin,
      })
      .send({
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

app.get("/deploy", (req, res) => {
  deploy().then((result) => {
    // result._provider.engine = undefined;
    // result._requestManager.provider.engine = undefined;
    res.send(result._address);
  });
});

app.listen(port, () => {
  console.log("Listeing...");
});
