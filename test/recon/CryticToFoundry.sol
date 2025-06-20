// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {FoundryAsserts} from "@chimera/FoundryAsserts.sol";
import "forge-std/console2.sol";

import {Test} from "forge-std/Test.sol";
import {TargetFunctions} from "./TargetFunctions.sol";
import { IBUILDClaimTargets } from "./targets/IBUILDClaimTargets.sol";
import { IBUILDFactoryTargets } from "./targets/IBUILDFactoryTargets.sol";
import "src/BUILDClaim.sol";
import "./Setup.sol";


// forge test --match-contract CryticToFoundry -vv
contract CryticToFoundry is Test, TargetFunctions, FoundryAsserts {
    function setUp() public {
        setup();
    }

    // forge test --match-test test_crytic -vvv
    function test_crytic() public {
        // TODO: add failing property tests here for debugging
    }

    function test_check_current_state() public {
        vm.warp(block.timestamp + 1 days);

        bytes32[] memory merkleProof = new bytes32[](1);
        merkleProof[0] = Setup.FOO;
        IBUILDClaim.ClaimParams[] memory claimParams = new IBUILDClaim.ClaimParams[](1); 
        claimParams[0] = IBUILDClaim.ClaimParams({
            seasonId: Setup.INITIAL_SEASON_ID,
            isEarlyClaim: false,
            proof: merkleProof,
            maxTokenAmount: Setup.INITIAL_DEPOSIT_AMOUNT / 2,
            salt: 0
        });

        IBUILDClaimTargets.iBUILDClaim_claim(_getActor(), claimParams);

        invariant_claim_within_allowed_limits();
    }
}