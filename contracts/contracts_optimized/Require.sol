// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedRequire {
    uint256 lastPurchaseTime;

    function purchaseToken() external payable {
        assembly {
            if or(
                iszero(eq(callvalue(), 100000000000000000)), // 0.1 ether
                iszero(gt(
                    timestamp(),
                    add(sload(lastPurchaseTime.slot), 60) // 1 minute
                ))
            ) {
                mstore(0x00, "cannot purchase")
                revert(0x00, 0x20)
            }
            sstore(lastPurchaseTime.slot, timestamp())
        }
    }
}
