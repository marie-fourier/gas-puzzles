// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedDistribute {
    address[4] public contributors;
    uint256 public createTime;

    constructor(address[4] memory _contributors) payable {
        contributors = _contributors;
        createTime = block.timestamp;
    }

    function distribute() external {
        require(
            block.timestamp > createTime + 1 weeks,
            "cannot distribute yet"
        );
        uint256 amount;
        assembly {
            amount := div(selfbalance(), 4)
        }
        payable(contributors[0]).transfer(amount);
        payable(contributors[1]).transfer(amount);
        payable(contributors[2]).transfer(amount);
        payable(contributors[3]).transfer(amount);
    }
}

// orig:                71 953
// unchecked amount:    71 897
// 