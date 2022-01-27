// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.9;

import {iOVM_L1BlockNumber} from "./interfaces/iOVM_L1BlockNumber.sol";

contract OVM_FakeL1BlockNumber is iOVM_L1BlockNumber {
    uint256 private blocknumber;

    function setL1BlockNumber(uint256 n) external {
        blocknumber = n;
    }

    function getL1BlockNumber() external view override returns (uint256) {
        return blocknumber;
    }
}
