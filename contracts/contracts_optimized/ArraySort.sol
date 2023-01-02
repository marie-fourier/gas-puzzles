// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedArraySort {
    function sortArray(uint256[] memory _data)
        external
        pure
        returns
        (uint256[] memory)
    {
        assembly {
            let dataLen := mload(_data)
            for { let i := 0 } lt(i, dataLen) { i := add(i, 1) }
            {
                for { let j := add(i, 1) } lt(j, dataLen) { j := add(j, 1) }
                {
                    let _i := add(_data, mul(0x20, add(i, 1)))
                    let _j := add(_data, mul(0x20, add(j, 1)))
                    let _dataI := mload(_i)
                    let _dataJ := mload(_j)
                    if gt(_dataI, _dataJ)
                    {
                        mstore(_i, _dataJ)
                        mstore(_j, _dataI)
                    }
                }
            }
        }
        return _data;
    }
}