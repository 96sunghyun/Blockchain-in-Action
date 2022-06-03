//SPDX-License-Identifier: unlicense
pragma solidity ^0.8.7;

contract BallotV2 {
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
  Phase public state = Phase.Init;

  modifier validPhase(Phase reqPhase) {
    require(state == reqPhase);
    _;
  }

  modifier onlyChair() {
    require(msg.sender == chairperson);
    _;
  }

  constructor(uint256 numProposals) {
    chairperson = msg.sender;
    voters[chairperson].weight = 2;
    for (uint256 i = 0; i < numProposals; i++) {
      proposals.push(Proposal(0));
    }
  }

  function changeState(Phase x) public onlyChair {
    require(x > state);
    state = x;
  }

  function register(address voter) public validPhase(Phase.Regs) onlyChair {
    require(!voters[voter].voted);
    voters[voter].weight = 1;
    voters[voter].voted = false;
  }

  function vote(uint256 toProposal) public validPhase(Phase.Vote) {
    Voter memory sender = voters[msg.sender];
    require(!sender.voted && toProposal < proposals.length);
    sender.voted = true;
    sender.vote = toProposal;
    proposals[toProposal].voteCount += sender.weight;
  }

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
    assert(winningVoteCount >= 3);
  }
}
