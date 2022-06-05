pragma solidity >=0.4.22 <=0.6.0;

contract BlindAuction {
  // bid Phase에서 자신이 내걸 금액에 salt를 추가한 keccak256 해시값을 parameter로 넣는다.
  // keccak 해시값은 "0x" + 32byte로 나온다.
  struct Bid {
    bytes32 blindedBid;
    uint256 deposit;
  }

  enum Phase {
    Init,
    Bidding,
    Reveal,
    Done
  }
  Phase public state = Phase.Init;

  address payable beneficiary;
  mapping(address => Bid) bids;

  address public highestBidder;
  uint256 public highestBid = 0;

  mapping(address => uint256) depositReturns;

  modifier validPhase(Phase reqPhase) {
    require(state == reqPhase);
    _;
  }

  modifier onlyBeneficiary() {
    msg.sender == beneficiary;
    _;
  }

  constructor() public {
    beneficiary = msg.sender;
    state = Phase.Bidding;
  }

  function changeState(Phase x) public onlyBeneficiary {
    require(x > state);
    state = x;
  }

  function bid(bytes32 blindBid) public payable validPhase(Phase.Bidding) {
    bids[msg.sender] = Bid({ blindedBid: blindBid, deposit: msg.value });
  }

  // 이 단계에서 입찰자는 자신이 내고자 한 금액과 salt값을 같이 입력한다.
  // 금액과 salt값을 keccak 함수로 해쉬하하여 이전에 제출한 hash값과 같으면, 입찰자가 입력한 금액은 맞는 금액이 된다.
  // 그 이후 이전 입찰자의 value와 비교하며 가장 큰 금액을 찾게된다.
  function reveal(uint256 value, bytes32 secret)
    public
    validPhase(Phase.Reveal)
  {
    uint256 refund = 0;
    // 여기선 원본 배열의 값을 변경하는 것이 아니라 그저 참조하여 비교하는 것이기 때문에 아래와 같이 굳이 storage를 사용할 필요가 없다.
    Bid storage bidtoCheck = bids[msg.sender];
    if (bidtoCheck.blindedBid == keccak256(abi.encodePacked(value, secret))) {
      refund = refund + bidtoCheck.deposit;
      // 예치금보다 낮은 금액만을 입력할 수 있다.
      if (bidtoCheck.deposit >= value) {
        if (placeBid(msg.sender, value)) {
          refund = refund - value;
        }
      }
    }
    msg.sender.transfer(refund);
  }

  function placeBid(address bidder, uint256 value)
    internal
    returns (bool success)
  {
    if (value <= highestBid) {
      return false;
    }
    // 이전에 highestBidder와 highestBid 값이 있다면, 변경될 것이기 때문에 이전 값을 이전 bidder에게 돌려줘야한다.
    // 이를 위해 depositReturns라는 매핑을 통해서 돌려줄 값을 기입해놓고, withdraw 함수에서 돌려준다.
    if (highestBidder != address(0)) {
      depositReturns[highestBidder] += highestBid;
    }
    // 새로운 최고가로 교체작업
    highestBid = value;
    highestBidder = bidder;
    return true;
  }

  function withdraw() public {
    uint256 amount = depositReturns[msg.sender];
    require(amount > 0);
    depositReturns[msg.sender] = 0;
    msg.sender.transfer(amount);
  }

  function aunctionEnd() public validPhase(Phase.Done) {
    beneficiary.transfer(highestBid);
  }
}
