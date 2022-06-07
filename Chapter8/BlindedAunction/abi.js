const abi = [
  { inputs: [], stateMutability: "nonpayable", type: "constructor" },
  {
    inputs: [],
    name: "aunctionEnd",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "bytes32", name: "blindBid", type: "bytes32" }],
    name: "bid",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [
      { internalType: "enum BlindAuction.Phase", name: "x", type: "uint8" },
    ],
    name: "changeState",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "highestBid",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "highestBidder",
    outputs: [{ internalType: "address", name: "", type: "address" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      { internalType: "uint256", name: "value", type: "uint256" },
      { internalType: "bytes32", name: "secret", type: "bytes32" },
    ],
    name: "reveal",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "state",
    outputs: [
      { internalType: "enum BlindAuction.Phase", name: "", type: "uint8" },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "withdraw",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

module.exports = { abi };
