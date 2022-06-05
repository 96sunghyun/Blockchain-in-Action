pragma solidity >=0.4.22 <=0.6.0;

contract Airlines {
  address chairperson;

  // 좌석교체 요청을 보내는 형식을 나타내는 구조체
  // 1. 요청번호 2. 비행 아이디(비행예정 리스트 중 몇번째 요소에 대한 요구인가) 3. 몇 좌석? 4. 승객 아이디 5. request를 받는 항공사 address
  struct reqStruc {
    uint256 reqID;
    uint256 fID;
    uint256 numSeats;
    uint256 passengerID;
    address toAirline;
  }

  // 좌석교체 요청에 대한 대답 형식을 나타내는 구조체
  // 1. 요청번호 2. 성공여부(좌석이 실제로 남아있고, 사용가능한지) 3. 요청을 보낸 항공사 address
  struct respStruc {
    uint256 reqID;
    bool status;
    address fromAirline;
  }

  mapping(address => uint256) public escrow;
  mapping(address => uint256) membership;
  mapping(address => reqStruc) reqs;
  mapping(address => respStruc) reps;
  mapping(address => uint256) settledReqID;

  modifier onlyChairperson() {
    require(msg.sender == chairperson);
    _;
  }

  modifier onlyMember() {
    require(membership[msg.sender] == 1);
    _;
  }

  constructor() public payable {
    chairperson = msg.sender;
    membership[msg.sender] = 1;
    escrow[msg.sender] = msg.value;
  }

  // ASK 서비스에 가입을 희망하는 항공사가 실행하는 함수
  function register() public payable {
    address AirlineA = msg.sender;
    membership[msg.sender] = 1;
    escrow[AirlineA] = msg.value;
  }

  // 회원삭제, chairperson만 실행할 수 있으며 남은 escrow(예치금)을 환불해줌
  function unregister(address payable AirlineZ) public onlyChairperson {
    membership[AirlineZ] = 0;
    AirlineZ.transfer(escrow[AirlineZ]);
    escrow[AirlineZ] = 0;
  }

  // request를 보내는 tx
  // 이에 앞서 offChain으로 request를 보내게 된다.
  // 이후 ASKrequest 함수를 실행하여 블록체인상에 거래기록(요청기록)을 남긴다.
  function ASKreqest(
    uint256 reqID,
    uint256 flightID,
    uint256 numSeats,
    uint256 custID,
    address toAirline
  ) public onlyMember {
    require(membership[toAirline] == 1);
    reqs[msg.sender] = reqStruc(reqID, flightID, numSeats, custID, toAirline);
  }

  // 마찬가지로 아래 함수 실행에 앞서 offChain으로 from 항공사에 response가 제공된다.
  // 이후 ASKresponse 함수를 실행하여 블록체인상에 응답기록을 남긴다.
  // 오류반환문과 mapping 내의 struct 정보 업데이트를 위와 다른 방식으로 작성하였다. 두 가지 방법 모두 사용 가능하다.
  function ASKresponse(
    uint256 reqID,
    bool success,
    address fromAirline
  ) public onlyMember {
    reps[msg.sender].status = success;
    reps[msg.sender].fromAirline = fromAirline;
    reps[msg.sender].reqID = reqID;
  }

  // 위 ASKresponse 함수의 결괏값이 reps[address].status == true 일 때 예치금을 이용하여 정산하는 함수
  // payment를 지급한다는 것은 seatChange가 성사되었다는 의미이고, 그러므로 함수 실행에 앞서 offChain에서는 남은 좌석수의 정보와 client에게 보여지는 table을 업데이트 해야한다.
  function settlePayment(
    uint256 reqID,
    address payable toAirline,
    uint256 numSeats
  ) public payable onlyMember {
    address fromAirline = msg.sender;
    escrow[toAirline] = escrow[toAirline] + numSeats * 1 ether;
    escrow[fromAirline] = escrow[fromAirline] - numSeats * 1 ether;
    settledReqID[fromAirline] = reqID;
  }

  // 예치금을 재충전하는 함수
  function reqlenishEscrow() public payable {
    escrow[msg.sender] = escrow[msg.sender] + msg.value;
  }
}

// 아무 연산도 하지 않는 ASKrequest()와 ASKresponse() 함수를 사용하는 이유
// => 단순히 이 함수의 파라미터를 스마트 컨트랙트의 변수로 기록하는, 즉 오프체인에서 일어난 오퍼레이션을 온체인 상태 또는 기록으로 저장하는 역할을 하는 것이다.
