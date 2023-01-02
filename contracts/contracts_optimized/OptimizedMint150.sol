//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// You may not modify this contract or the openzeppelin contracts
contract NotRareToken is ERC721 {
    mapping(address => bool) private alreadyMinted;

    uint256 private totalSupply;

    constructor() ERC721("NotRareToken", "NRT") {}

    function mint() external {
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
        alreadyMinted[msg.sender] = true;
    }
}

contract OptimizedAttacker {
    constructor(address victim) {
        unchecked {
            uint256 offset = IERC721(victim).balanceOf(IERC721(victim).ownerOf(1)) + 1;
            // minted once to make the balance non-zero
            // otherwise it will make it zero and then non-zero
            // on each iteration, which is expensive
            NotRareToken(victim).mint();
            for (uint256 i = 1; i < 150; i++) {
                NotRareToken(victim).mint();
                IERC721(victim).transferFrom(address(this), msg.sender, i + offset);
            }
            IERC721(victim).transferFrom(address(this), msg.sender, offset);
        }
    }
}
