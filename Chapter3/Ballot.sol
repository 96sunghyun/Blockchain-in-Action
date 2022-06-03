//SPDX-License-Identifier: unlicense
pragma solidity ^0.8.7;

contract Ballot {
  // 투표자 struct 생성, weight : 투표권, voted : 투표여부, vote : 어디에 투표했는가
  struct Voter {
    uint256 weight;
    bool voted;
    uint256 vote;
  }
  // 제안된 투표 안건, voteCount : 안건에 투표된 숫자
  struct Proposal {
    uint256 voteCount;
  }

  address chairperson;
  mapping(address => Voter) voters;
  Proposal[] proposals;

  // 네가지 단계별 국면, chairperson만 변경 가능하다.
  enum Phase {
    Init,
    Regs,
    Vote,
    Done
  }

  Phase public state = Phase.Init;

  // 국면별로 알맞은 Phase에 알맞은 action을 할 수 있도록 규제하는 modifier
  modifier validPhase(Phase reqPhase) {
    require(state == reqPhase);
    _;
  }

  modifier onlyChair() {
    require(msg.sender == chairperson);
    _;
  }

  // 배포시 몇 가지의 안건을 가지고 투표를 할지 규정해놓음
  constructor(uint256 numProposals) {
    chairperson = msg.sender;
    voters[chairperson].weight = 2;
    for (uint256 i = 0; i < numProposals; i++) {
      proposals.push(Proposal(0));
    }
  }

  // Phase의 국면을 바꾸는 함수
  function changeState(Phase x) public onlyChair {
    require(x > state);
    state = x;
  }

  // 투표 참가자를 추가하는 함수
  function register(address voter) public validPhase(Phase.Regs) onlyChair {
    require(!voters[voter].voted);
    voters[voter].weight = 1;
    voters[voter].voted = false;
  }

  // 투표를 하는 함수
  function vote(uint256 toProposal) public validPhase(Phase.Vote) {
    Voter memory sender = voters[msg.sender];
    require(!sender.voted && toProposal < proposals.length);
    sender.voted = true;
    sender.vote = toProposal;
    proposals[toProposal].voteCount += sender.weight;
  }

  // 투표 결과를 요청하는 함수
  function reqWinner()
    public
    view
    validPhase(Phase.Done)
    returns (uint256 winningProposal)
  {
    uint256 winningVoteCount = 0;
    for (uint256 i = 0; i < proposals.length; i++) {
      if (proposals[i].voteCount > winningVoteCount) {
        winningVoteCount = proposals[i].voteCount;
        winningProposal = i;
      }
    }

    // require같은 경우 변수의 리미트(ex: age >= 18;)를 체크하는 것과 같은 일반적인 검증에 사용한다. 이 체크에 실패할 가능성이 있다고 예상하는 경우다.
    // 반면 assert는 예외를 다루기 위한 것으로, 이 조건은 보통 실패하지 말아야 한다고 가정한다. assert는 예외 처리를 위한 곳에 간헐적으로 사용하게 된다.
    // 이 함수에서 assert는 연산 후, 연산의 결과가 타당하지 않으면 돌리는 역할을 한다.
    assert(winningVoteCount >= 3);
  }
}
