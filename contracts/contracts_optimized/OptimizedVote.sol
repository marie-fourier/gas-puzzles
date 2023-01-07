// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.15;

import "hardhat/console.sol";

contract OptimizedVote {
    struct Voter {
      uint8 vote;
      bool voted;
    }

    struct Proposal {
      uint8 voteCount;
      bool ended;
      bytes32 name;
    }

    mapping(address => Voter) public voters;

    Proposal[] proposals;

    function createProposal(bytes32 _name) external {
      proposals.push(Proposal({voteCount: 0, name: _name, ended: false}));
    }

    function vote(uint8 _proposal) external {
      Voter storage voter = voters[msg.sender];
      require(!voter.voted, 'already voted');
      assembly {
        sstore(voter.slot, add(0x100, _proposal))
      }
      proposals[_proposal].voteCount++;
    }

    function getVoteCount(uint8 _proposal) external view returns (uint8) {
      return proposals[_proposal].voteCount;
    }
}

/*
  Current gas use:   136375
  The gas target is: 136508
*/