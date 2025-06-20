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
import {StdCheats} from "forge-std/StdCheats.sol";
import "@openzeppelin/contracts/utils/Strings.sol";



abstract contract Setup is BaseSetup, ActorManager, AssetManager, Utils, StdCheats {
    bytes32 public FOO = 0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;

    IBUILDFactory iBUILDFactory;
    IBUILDClaim iBUILDClaim;
    address token;

    uint256 INITIAL_DEPOSIT_AMOUNT = 1000 ether;
    uint256 MAX_UNLOCK_DURATION = 30 days;
    uint256 MAX_UNLOCK_DELAY = 7 days;
    uint32 public INITIAL_SEASON_ID = 1;

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

        //configure season
        setupProjectSeason();

        //add users
        addUsersPool();

        //1. define invariant based on states
        //2. add active season (unlocking)
        //3. fuzz claim
        //4. move to refund? fuzz remaining tokens
    }

    function setupProjectSeason() internal {
        iBUILDFactory.setSeasonUnlockStartTime(INITIAL_SEASON_ID, block.timestamp + 1 seconds);
        IBUILDFactory.SetProjectSeasonParams[] memory seasonParams = new  IBUILDFactory.SetProjectSeasonParams[](1);
        seasonParams[0] = IBUILDFactory.SetProjectSeasonParams({
            seasonId: INITIAL_SEASON_ID,
            token: _getAsset(),
            config: IBUILDFactory.ProjectSeasonConfig({
                tokenAmount: INITIAL_DEPOSIT_AMOUNT,
                merkleRoot: FOO,
                unlockDelay: 0,
                unlockDuration: 5 days,
                earlyVestRatioMinBps: 2000,
                earlyVestRatioMaxBps: 6000,
                baseTokenClaimBps: 2000,
                isRefunding: false
            })
        });

        iBUILDFactory.setProjectSeasonConfig(seasonParams);
    }

    function addUsersPool() internal {
        for (uint i = 0; i < 50; i++) {
            string memory userName = string.concat("user", Strings.toString(i));
            _addActor(makeAddr(userName));
        }
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
