// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import {Vm} from "forge-std/Vm.sol";

import {Lib_PredeployAddresses} from "./lib/Lib_PredeployAddresses.sol";
import {iOVM_CrossDomainMessenger} from "./interfaces/iOVM_CrossDomainMessenger.sol";
import {OVM_FakeCrossDomainMessenger} from "./OVM_FakeCrossDomainMessenger.sol";
import {iOVM_L1BlockNumber} from "./interfaces/iOVM_L1BlockNumber.sol";

contract OptimismTest {
    Vm private constant vm =
        Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    iOVM_CrossDomainMessenger internal l1cdm =
        OVM_FakeCrossDomainMessenger(
            0x25ace71c97B33Cc4729CF772ae268934F7ab5fA1
        );

    function setUp() public virtual {
        vm.etch(
            0x25ace71c97B33Cc4729CF772ae268934F7ab5fA1,
            type(OVM_FakeCrossDomainMessenger).runtimeCode
        );

        // Deploy CDM at predeploy address
        vm.etch(
            Lib_PredeployAddresses.L2_CROSS_DOMAIN_MESSENGER,
            type(OVM_FakeCrossDomainMessenger).runtimeCode
        );
    }
}

contract OptimismVm {
    Vm constant vm =
        Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function warp(uint256 n) external {
        vm.mockCall(
            Lib_PredeployAddresses.L1_BLOCK_NUMBER,
            abi.encodeWithSelector(
                iOVM_L1BlockNumber.getL1BlockNumber.selector
            ),
            abi.encode(n)
        );
    }
}
