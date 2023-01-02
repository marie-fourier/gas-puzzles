// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedDistribute {
    // the immutable variables will not get stored in the storage.
    // all references to these values will be replaced by the values
    // they are assigned to in the constructor
    // thus this will save us a lot of cold storage reads
    address payable immutable contributors0;
    address payable immutable contributors1;
    address payable immutable contributors2;
    address payable immutable contributors3;
    uint256 public immutable releaseTime;

    constructor(address payable[4] memory _contributors) payable {
        contributors0 = _contributors[0];
        contributors1 = _contributors[1];
        contributors2 = _contributors[2];
        contributors3 = _contributors[3];
        releaseTime = block.timestamp + 1 weeks;
    }

    function distribute() external { // 21,000
        require(
            block.timestamp > releaseTime,
            "cannot distribute yet"
        );
        uint256 amount = address(this).balance >> 2;
        contributors0.transfer(amount);
        contributors1.transfer(amount);
        contributors2.transfer(amount);
        selfdestruct(contributors3);
    }
}