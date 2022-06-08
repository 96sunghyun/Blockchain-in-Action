const Counter = artifacts.require("../contracts/Counter.sol");
const truffleAssert = require("truffle-assertions");

contract("Counter", () => {
  let counter;
  const negativeCounterError = "Counter cannot become negative";
  const negativeValueError = "value must be greater than zero";

  beforeEach("Setup contract for each test", async () => {
    counter = await Counter.new();
    await counter.initialize(100);
  });

  it("Success on initialization of counter.", async () => {
    assert.equal(await counter.get(), 100);
  });

  it("Success on decrement of counter", async () => {
    await counter.decrement(5);
    assert.equal(await counter.get(), 95);
  });

  it("Successon increment of counter", async () => {
    await counter.increment(5);
    assert.equal(await counter.get(), 105);
  });

  it("Failure on initialization of counter with negative number", async () => {
    await truffleAssert.reverts(
      counter.initialize(-1),
      truffleAssert.ErrorType.REVERT,
      negativeValueError
    );
  });

  it("Failure on underflow of counter", async () => {
    await truffleAssert.reverts(
      counter.decrement(105),
      truffleAssert.ErrorType.REVERT,
      negativeCounterError
    );
  });

  it("Failure on increment with negartive numbers", async () => {
    await truffleAssert.reverts(
      counter.increment(-2),
      truffleAssert.ErrorType.REVERT,
      negativeValueError
    );
  });

  it("Failure  on decrement with negative numbers", async () => {
    await truffleAssert.reverts(
      counter.decrement(-2),
      truffleAssert.ErrorType.REVERT,
      "no!!"
    );
  });
});
