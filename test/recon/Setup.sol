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
    address token;

    uint256 INITIAL_DEPOSIT_AMOUNT = 1000 ether;
    uint256 MAX_UNLOCK_DURATION = 30 days;
    uint256 MAX_UNLOCK_DELAY = 7 days;

    function setup() internal virtual override {
        address adminAddr = address(this);
        token = _newAsset(18); // Create a new asset for the token, adjust decimals as needed

        BUILDFactory.ConstructorParams memory params = BUILDFactory.ConstructorParams({
            admin: adminAddr,
            maxUnlockDuration: 30 days, // Example value, adjust as needed
            maxUnlockDelay: 7 days, // Example value, adjust as needed
            delegateRegistry: IDelegateRegistry(new DelegateRegistry()) // Example delegate registry, adjust as needed
        }); // Example delegate registry, adjust as needed

        iBUILDFactory = IBUILDFactory(address(new BUILDFactory(params))); // TODO: Add parameters here
        
        IBUILDFactory.AddProjectParams[] memory addProjectParams = new IBUILDFactory.AddProjectParams[](1);
        addProjectParams[0] = IBUILDFactory.AddProjectParams({
            token: token,
            admin: adminAddr
        });
        iBUILDFactory.addProjects(addProjectParams); // Cast to BUILDClaim type
        iBUILDClaim = iBUILDFactory.deployClaim(token); // TODO: Add parameters here
        
        address[] memory receivers = new address[](1);
        receivers[0] = adminAddr;
        address[] memory approved = new address[](1);
        approved[0] = address(iBUILDClaim);
        
        _finalizeAssetDeployment(receivers, approved, INITIAL_DEPOSIT_AMOUNT);
        iBUILDClaim.deposit(INITIAL_DEPOSIT_AMOUNT);

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
