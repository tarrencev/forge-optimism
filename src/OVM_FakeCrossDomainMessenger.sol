// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import {Vm} from "forge-std/Vm.sol";

import {iOVM_CrossDomainMessenger} from "./interfaces/iOVM_CrossDomainMessenger.sol";

contract OVM_FakeCrossDomainMessenger is iOVM_CrossDomainMessenger {
    Vm private constant vm =
        Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    address sender;
    OVM_FakeCrossDomainMessenger private constant l1cdm =
        OVM_FakeCrossDomainMessenger(
            0x25ace71c97B33Cc4729CF772ae268934F7ab5fA1
        );
    OVM_FakeCrossDomainMessenger private constant l2cdm =
        OVM_FakeCrossDomainMessenger(
            0x4200000000000000000000000000000000000007
        );

    function xDomainMessageSender() external view override returns (address) {
        return sender;
    }

    function setSender(address from) external {
        sender = from;
    }

    event log_address(address);

    function sendMessage(
        address _target,
        bytes calldata _message,
        uint32 _gasLimit
    ) external override {
        sender = msg.sender;

        // Pretend we're the other side
        if (address(this) == address(l2cdm)) {
            l1cdm.setSender(l2cdm.xDomainMessageSender());
            vm.startPrank(address(l1cdm));
        } else if (address(this) == address(l1cdm)) {
            l2cdm.setSender(l1cdm.xDomainMessageSender());
            vm.startPrank(address(l2cdm));
        }

        (bool success, ) = address(_target).call{gas: _gasLimit}(_message);
        require(success, "cdm call fail");
        vm.stopPrank();
    }
}
