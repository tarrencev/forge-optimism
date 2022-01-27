// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.9;

import {Vm} from "forge-std/Vm.sol";

import {Lib_PredeployAddresses} from "./lib/Lib_PredeployAddresses.sol";
import {iOVM_CrossDomainMessenger} from "./interfaces/iOVM_CrossDomainMessenger.sol";
import {OVM_FakeCrossDomainMessenger} from "./OVM_FakeCrossDomainMessenger.sol";

contract OptimismTest {
    Vm private constant vm =
        Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    iOVM_CrossDomainMessenger internal immutable l1cdm;

    constructor() {
        // Deploy CDM at predeploy address
        vm.etch(
            Lib_PredeployAddresses.L2_CROSS_DOMAIN_MESSENGER,
            type(OVM_FakeCrossDomainMessenger).runtimeCode
        );

        vm.etch(
            // L1 CDM Address
            0x4361d0F75A0186C05f971c566dC6bEa5957483fD,
            type(OVM_FakeCrossDomainMessenger).runtimeCode
        );

        l1cdm = iOVM_CrossDomainMessenger(
            0x4361d0F75A0186C05f971c566dC6bEa5957483fD
        );
    }
}
