// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.9;

import {Lib_PredeployAddresses} from "./lib/Lib_PredeployAddresses.sol";
import {iOVM_CrossDomainMessenger} from "./interfaces/iOVM_CrossDomainMessenger.sol";

contract OVM_FakeCrossDomainMessenger is iOVM_CrossDomainMessenger {
    address sender;

    function xDomainMessageSender() external view override returns (address) {
        return sender;
    }

    function sendMessage(
        address _target,
        bytes calldata _message,
        uint32 _gasLimit
    ) external override {
        sender = msg.sender;
        (bool success, ) = address(_target).call{gas: _gasLimit}(_message);
        require(success, "cdm call fail");
    }
}
