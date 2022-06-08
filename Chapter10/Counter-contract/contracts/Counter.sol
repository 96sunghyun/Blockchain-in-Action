//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.7;

contract Counter {
  int256 value;

  constructor() {
    value = 0;
  }

  modifier checkIfLessThanValue(int256 n) {
    require(n <= value, "Counter cannot become negative");
    _;
  }

  modifier checkIfNegative(int256 n) {
    require(n > 0, "Value must be greater than zero");
    _;
  }

  function get() public view returns (int256) {
    return value;
  }

  function initialize(int256 n) public checkIfNegative(n) {
    value = n;
  }

  function increment(int256 n) public checkIfNegative(n) {
    value = value + n;
  }

  function decrement(int256 n)
    public
    checkIfNegative(n)
    checkIfLessThanValue(n)
  {
    value = value - n;
  }
}
