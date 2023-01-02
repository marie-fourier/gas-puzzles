// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedRequire {
    uint256 lastPurchaseTime = 1; // settings non-zero value to zero costs 20k

    function purchaseToken() external payable {
        assembly {
            if or(
                iszero(eq(callvalue(), 100000000000000000)), // 0.1 ether
                iszero(gt(
                    timestamp(),
                    add(sload(lastPurchaseTime.slot), 60) // 1 minute
                ))
            ) {
                mstore(0x00, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                mstore(0x20, 0x0000002000000000000000000000000000000000000000000000000000000000)
                mstore(0x40, 0x0000000f63616e6e6f7420707572636861736500000000000000000000000000)
                revert(0x00, 0x64)
            }
            sstore(lastPurchaseTime.slot, timestamp())
        }
    }
}
