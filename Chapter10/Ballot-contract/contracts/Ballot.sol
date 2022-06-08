pragma solidity >=0.4.22 <0.6.0;

contract Ballot {
  struct Voter {
    uint256 weight;
    bool voted;
    uint256 vote;
  }
  struct Proposal {
    uint256 voteCount;
  }

  address chairperson;
  mapping(address => Voter) voters;
  Proposal[] proposals;

  enum Phase {
    Init,
    Regs,
    Vote,
    Done
  }
  Phase public state = Phase.Done;

  modifier validPhase(Phase reqPhase) {
    require(state == reqPhase, "Not the required phase");
    _;
  }
  modifier onlyChair() {
    require(
      msg.sender == chairperson,
      "Only chairperson can perform this operation"
    );
    _;
  }

  constructor(uint256 numProposals) public {
    chairperson = msg.sender;
    voters[chairperson].weight = 2;
    proposals.length = numProposals;
    state = Phase.Regs;
  }

  function changeState(Phase x) public onlyChair {
    require(x > state, "Can only move to greater state");
    state = x;
  }

  function register(address voter) public validPhase(Phase.Regs) onlyChair {
    require(!voters[voter].voted);
    voters[voter].weight = 1;
  }

  function vote(uint256 toProposal) public validPhase(Phase.Vote) {
    require(!voters[msg.sender].voted, "Voter has already voted");
    require(toProposal < proposals.length, "Proposal number over limit");

    voters[msg.sender].voted = true;
    voters[msg.sender].vote = toProposal;
    proposals[toProposal].voteCount += voters[msg.sender].weight;
  }

  function reqWinner()
    public
    view
    validPhase(Phase.Done)
    returns (uint256 winningProposal)
  {
    uint256 winningVoteCount = 0;
    for (uint256 prop = 0; prop < proposals.length; prop++) {
      if (proposals[prop].voteCount > winningVoteCount) {
        winningVoteCount = proposals[prop].voteCount;
        winningProposal = prop;
      }
    }
    assert(winningVoteCount >= 3);
  }
}
