// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.9;

import {Vm} from "forge-std/Vm.sol";

import {iOVM_L1BlockNumber} from "./interfaces/iOVM_L1BlockNumber.sol";
import {Lib_PredeployAddresses} from "./lib/Lib_PredeployAddresses.sol";

library Optimism {
    Vm constant vm =
        Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function setL1BlockNumber(uint256 n) external {
        vm.mockCall(
            Lib_PredeployAddresses.L1_BLOCK_NUMBER,
            abi.encodeWithSelector(
                iOVM_L1BlockNumber.getL1BlockNumber.selector,
                n
            )
        );
    }
}
