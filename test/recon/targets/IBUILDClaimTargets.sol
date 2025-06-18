// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {BeforeAfter} from "../BeforeAfter.sol";
import {Properties} from "../Properties.sol";
// Chimera deps
import {vm} from "@chimera/Hevm.sol";

// Helpers
import {Panic} from "@recon/Panic.sol";

import "src/interfaces/IBUILDClaim.sol";

abstract contract IBUILDClaimTargets is
    BaseTargetFunctions,
    Properties
{
    /// CUSTOM TARGET FUNCTIONS - Add your own target functions here ///


    /// AUTO GENERATED TARGET FUNCTIONS - WARNING: DO NOT DELETE OR MODIFY THIS LINE ///

    function iBUILDClaim_claim(address user, IBUILDClaim.ClaimParams[] memory params) public asActor {
        iBUILDClaim.claim(user, params);
    }

    function iBUILDClaim_deposit(uint256 amount) public asActor {
        iBUILDClaim.deposit(amount);
    }

    function iBUILDClaim_withdraw() public asActor {
        iBUILDClaim.withdraw();
    }
}