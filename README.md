# forge-optimism

Forge Optimism is a collection of helpful contracts for use with forge and foundry. It leverages forge's cheatcodes to allow tests to easily setup and manipulation optimism predeploys.

## Installation

```bash
forge install tarrencev/forge-optimism
```

## Contracts

`src/OptimismTest.sol`

Sets up the Optimism execution context for the test.

- Configures `Proxy__OVM_L1CrossDomainMessenger` and `L2CrossDomainMessenger` to enable simulating message passing between chains.
- Implements `OptimismVm` which exposes cheat codes for manipulating the optimism execution context (values returned by predeploys).

### Usage

```solidity
import {OptimismVm, OptimismTest} from "forge-optimism/Optimism.sol";
import {iOVM_L1BlockNumber} from "forge-optimism/interfaces/iOVM_L1BlockNumber.sol";
import {iOVM_CrossDomainMessenger} from "forge-optimism/interfaces/iOVM_CrossDomainMessenger.sol";
import {Lib_PredeployAddresses} from "forge-optimism/lib/Lib_PredeployAddresses.sol";

contract Test is OptimismTest, DSTest {
    OptimismVm internal ovm = new OptimismVm();

    ...

    function testSomething() public {
        // Make a call to the L1 xCrossDomainMessenger, preconfigured to the mainnet address
        l1cdm.sendMessage(target, abi.encodeWithSelector(...), 0);

        // Make a call to the L2 xCrossDomainMessenger
        iOVM_CrossDomainMessenger(Lib_PredeployAddresses.L2_CROSS_DOMAIN_MESSENGER).sendMessage(target, abi.encodeWithSelector(...), 0);

        // Set the return value of OVM_L1BlockNumber.getL1BlockNumber
        ovm.warp(10);
        assertEq(iOVM_L1BlockNumber(Lib_PredeployAddresses.L1_BLOCK_NUMBER).getL1BlockNumber(), 10);
    }
}
```
