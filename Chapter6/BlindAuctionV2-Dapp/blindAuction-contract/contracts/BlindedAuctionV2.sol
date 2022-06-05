pragma solidity >=0.4.22 <=0.6.0;

contract BlindAuction {
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

  Phase public currentPhase = Phase.Init;

  address payable beneficiary;
  mapping(address => Bid) bids;

  address public highestBidder;
  uint256 public highestBid = 0;

  mapping(address => uint256) depositReturns;

  // 이벤트 선언 추가
  event AuctionEnded(address winner, uint256 highestBid);
  event BiddingStarted();
  event RevealStarted();

  modifier validPhase(Phase reqPhase) {
    require(currentPhase == reqPhase);
    _;
  }

  modifier onlyBeneficiary() {
    require(msg.sender == beneficiary);
    _;
  }

  constructor() public {
    beneficiary = msg.sender;
    currentPhase = Phase.Bidding;
  }

  //   function changeState(Phase x) public onlyBeneficiary {
  //     require(x > state);
  //     state = x;
  //   }
  // changeState 함수 변경
  function advancePhase() public onlyBeneficiary {
    if (currentPhase == Phase.Done) {
      currentPhase = Phase.Init;
    } else {
      // enumtype에 1을 더하려면 uint로 전환 후 해줘야 하며
      // 반대의 경우에도 enum 안에 uint형식의 value를 넣어 전환해줘야 정상작동한다.
      uint256 nextPhase = uint256(currentPhase) + 1;
      currentPhase = Phase(nextPhase);
    }
    // currentPhase 상태에 따른 이벤트 호출
    if (currentPhase == Phase.Reveal) emit RevealStarted();
    if (currentPhase == Phase.Bidding) emit BiddingStarted();
  }

  function bid(bytes32 blindBid) public payable validPhase(Phase.Bidding) {
    bids[msg.sender] = Bid({ blindedBid: blindBid, deposit: msg.value });
  }

  function reveal(uint256 value, bytes32 secret)
    public
    validPhase(Phase.Reveal)
  {
    uint256 refund = 0;
    Bid memory bidtoCheck = bids[msg.sender];
    if (bidtoCheck.blindedBid == keccak256(abi.encodePacked(value, secret))) {
      refund = refund + bidtoCheck.deposit;
      if (bidtoCheck.deposit >= value) {
        if (placeBid(msg.sender, value)) {
          if (placeBid(msg.sender, value)) {
            refund = refund - value;
          }
        }
      }
    }
    msg.sender.transfer(refund);
  }

  function placeBid(address bidder, uint256 value) internal returns (bool) {
    if (value <= highestBid) {
      return false;
    }
    if (highestBidder != address(0)) {
      depositReturns[highestBidder] += highestBid;
    }
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
    // 최고가 낙찰자 추소와 amount 이벤트로 알림
    emit AuctionEnded(highestBidder, highestBid);
  }
}
