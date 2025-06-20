// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Asserts} from "@chimera/Asserts.sol";
import {BeforeAfter} from "./BeforeAfter.sol";
import {Setup} from './Setup.sol';
import "src/interfaces/IBUILDClaim.sol";
import "src/BUILDClaim.sol";
import "src/interfaces/IBUILDFactory.sol";
import "src/BUILDFactory.sol";

abstract contract Properties is BeforeAfter, Asserts {
    
    function invariant_claim_within_allowed_limits() public view {
        // currently unused:
        // address[] memory projects = iBUILDFactory.getProjects();
        // address firstProject = projects[0];

        (IBUILDFactory.ProjectSeasonConfig memory config, 
        uint256 unlockStartsAt,
        IBUILDClaim.UserState memory userState,
        IBUILDClaim.GlobalState memory globalState,
        BUILDClaim.UnlockState memory unlockState,
        IBUILDClaim.ClaimableState memory claimableState) = getCurrentStates(Setup.INITIAL_SEASON_ID);

            
        // invariants: 
        // userState.claimed <= config.tokenAmount
        // claimableState.claimed == userState.claimed
        // claimableState.bonus = config.tokenAmount - userState.claimed
        // claimableState.vested <= claimableState.bonus
        // claimableState.earlyVestableBonus <= claimableState.bonus
        // claimableState.claimable = 
    }

    function getCurrentStates(uint256 seasonId) internal view returns (
        IBUILDFactory.ProjectSeasonConfig memory config, 
        uint256 unlockStartsAt,
        IBUILDClaim.UserState memory userState,
        IBUILDClaim.GlobalState memory globalState,
        BUILDClaim.UnlockState memory unlockState,
        IBUILDClaim.ClaimableState memory claimableState
    )
    {
        BUILDClaim bUILDClaim = BUILDClaim(address(iBUILDClaim));
        (config, unlockStartsAt) = iBUILDFactory.getProjectSeasonConfig(_getAsset(), seasonId);
                        
        //global season state
        globalState = iBUILDClaim.getGlobalState(INITIAL_SEASON_ID);
            
        //user current state
        IBUILDClaim.UserSeasonId[] memory seasonIdConfigs = new IBUILDClaim.UserSeasonId[](1);
        seasonIdConfigs[0] = IBUILDClaim.UserSeasonId({user: _getActor(), seasonId: INITIAL_SEASON_ID});
        BUILDClaim.UserState[] memory userStates = iBUILDClaim.getUserState(seasonIdConfigs);
        userState = userStates[0];

        //unlock state
        unlockState = bUILDClaim._getUnlockState(
            unlockStartsAt,
            config.unlockDelay, 
            config.unlockDuration, 
            block.timestamp
        );

        //Claimable state
        claimableState = bUILDClaim._getClaimableState(
            config,
            globalState,
            userState,
            unlockState,
            config.tokenAmount //TODO: currently, we are testing with 1 user in a project, whose tokens will be equal to the tokenAmount of the season configured

        );
    }
}