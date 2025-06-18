// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {BeforeAfter} from "../BeforeAfter.sol";
import {Properties} from "../Properties.sol";
// Chimera deps
import {vm} from "@chimera/Hevm.sol";

// Helpers
import {Panic} from "@recon/Panic.sol";

import "src/interfaces/IBUILDFactory.sol";

abstract contract IBUILDFactoryTargets is
    BaseTargetFunctions,
    Properties
{
    /// CUSTOM TARGET FUNCTIONS - Add your own target functions here ///


    /// AUTO GENERATED TARGET FUNCTIONS - WARNING: DO NOT DELETE OR MODIFY THIS LINE ///

    function iBUILDFactory_addProjects(IBUILDFactory.AddProjectParams[] memory projects) public asActor {
        iBUILDFactory.addProjects(projects);
    }

    function iBUILDFactory_addTotalDeposited(address token, uint256 amount) public asActor {
        iBUILDFactory.addTotalDeposited(token, amount);
    }

    function iBUILDFactory_cancelWithdraw(address token) public asActor {
        iBUILDFactory.cancelWithdraw(token);
    }

    function iBUILDFactory_deployClaim(address token) public asActor {
        iBUILDFactory.deployClaim(token);
    }

    function iBUILDFactory_executeWithdraw(address token) public asActor {
        iBUILDFactory.executeWithdraw(token);
    }

    function iBUILDFactory_pauseClaimContract(address token) public asActor {
        iBUILDFactory.pauseClaimContract(token);
    }

    function iBUILDFactory_reduceRefundableAmount(address token, uint256 seasonId, uint256 amount) public asActor {
        iBUILDFactory.reduceRefundableAmount(token, seasonId, amount);
    }

    function iBUILDFactory_removeProjects(address[] memory tokens) public asActor {
        iBUILDFactory.removeProjects(tokens);
    }

    function iBUILDFactory_scheduleWithdraw(address token, address recipient, uint256 amount) public asActor {
        iBUILDFactory.scheduleWithdraw(token, recipient, amount);
    }

    function iBUILDFactory_setProjectSeasonConfig(IBUILDFactory.SetProjectSeasonParams[] memory params) public asActor {
        iBUILDFactory.setProjectSeasonConfig(params);
    }

    function iBUILDFactory_setSeasonUnlockStartTime(uint256 seasonId, uint256 unlockStartsAt) public asActor {
        iBUILDFactory.setSeasonUnlockStartTime(seasonId, unlockStartsAt);
    }

    function iBUILDFactory_setUnlockConfigMaxValues(IBUILDFactory.UnlockMaxConfigs memory config) public asActor {
        iBUILDFactory.setUnlockConfigMaxValues(config);
    }

    function iBUILDFactory_startRefund(address token, uint256 seasonId) public asActor {
        iBUILDFactory.startRefund(token, seasonId);
    }

    function iBUILDFactory_unpauseClaimContract(address token) public asActor {
        iBUILDFactory.unpauseClaimContract(token);
    }
}