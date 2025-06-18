// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

// Chimera deps
import {BaseSetup} from "@chimera/BaseSetup.sol";
import {vm} from "@chimera/Hevm.sol";

// Managers
import {ActorManager} from "@recon/ActorManager.sol";
import {AssetManager} from "@recon/AssetManager.sol";

// Helpers
import {Utils} from "@recon/Utils.sol";

// Your deps
import "src/BUILDClaim.sol";
import "src/BUILDFactory.sol";
import {DelegateRegistry} from "@delegatexyz/delegate-registry/v2.0/src/DelegateRegistry.sol";
import {IDelegateRegistry} from "@delegatexyz/delegate-registry/v2.0/src/IDelegateRegistry.sol";

abstract contract Setup is BaseSetup, ActorManager, AssetManager, Utils {
    IBUILDFactory iBUILDFactory;
    IBUILDClaim iBUILDClaim;

    /// === Setup === ///
    /// This contains all calls to be performed in the tester constructor, both for Echidna and Foundry
    function setup() internal virtual override {
        iBUILDFactory = IBUILDFactory(
            address(
                new BUILDFactory(
                    BUILDFactory.ConstructorParams({
                        admin: address(this),
                        maxUnlockDuration: 7 days,
                        maxUnlockDelay: 1 days,
                        delegateRegistry: IDelegateRegistry(
                            new DelegateRegistry()
                        )
                    })
                )
            )
        );

        iBUILDClaim = iBUILDFactory.deployClaim(_newAsset(18));
    }

    /// === MODIFIERS === ///
    /// Prank admin and actor

    modifier asAdmin() {
        vm.prank(address(this));
        _;
    }

    modifier asActor() {
        vm.prank(address(_getActor()));
        _;
    }
}
