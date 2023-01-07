// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedRequire {
    uint256 lastPurchaseTime = 1;

    function purchaseToken() external payable {
        assembly {
            if or(
                iszero(eq(callvalue(), 100000000000000000)), // 0.1 ether
                iszero(gt(
                    timestamp(),
                    add(sload(lastPurchaseTime.slot), 60) // 1 minute
                ))
            ) {
                // EIP 838
                let error := 0x00
                mstore(error, 0x08c379a0) // error selector
                mstore(add(error, 0x20), 0x20) // string offset
                mstore(add(error, 0x40), 0x0f) // length("cannot purchase") = 0x0f bytes
                mstore(add(error, 0x60), 0x63616e6e6f742070757263686173650000000000000000000000000000000000) // "cannot purchase"
                revert(add(error, 0x1c), sub(0x80, 0x1c)) // error selector bytes start at (error + 28bytes)
            }
            sstore(lastPurchaseTime.slot, timestamp())
        }
    }
}
