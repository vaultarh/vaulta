// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {VaultaStableVault} from "../src/VaultaStableVault.sol";
import {IMorpho, MarketParams} from "../src/interfaces/IMorpho.sol";

/// @notice Deploys VaultaStableVault on Robinhood Chain Testnet, wired to the
///         USDG/USDe Morpho Blue market (mirrors the most liquid mainnet market).
///
/// Usage:
///   forge script script/DeployTestnet.s.sol:DeployTestnet \
///     --rpc-url $RH_TESTNET_RPC --broadcast --private-key $PRIVATE_KEY \
///     --verify --verifier blockscout --verifier-url $RH_TESTNET_EXPLORER_API
contract DeployTestnet is Script {
    // Robinhood Chain Testnet (chainId 46630) addresses — MUST be re-verified against
    // testnet deployments before running; testnet market/token addresses are seeded
    // independently of mainnet and are not guaranteed to match mainnet 1:1.
    function run() external {
        address morphoAddr = vm.envAddress("MORPHO_ADDRESS");
        address usdgAddr = vm.envAddress("USDG_ADDRESS");
        address collateralAddr = vm.envAddress("COLLATERAL_ADDRESS");
        address oracleAddr = vm.envAddress("ORACLE_ADDRESS");
        address irmAddr = vm.envAddress("IRM_ADDRESS");
        uint256 lltv = vm.envUint("LLTV");
        address ownerAddr = vm.envAddress("VAULT_OWNER");

        MarketParams memory params = MarketParams({
            loanToken: usdgAddr,
            collateralToken: collateralAddr,
            oracle: oracleAddr,
            irm: irmAddr,
            lltv: lltv
        });

        vm.startBroadcast();

        VaultaStableVault vault = new VaultaStableVault(
            IERC20(usdgAddr),
            "Vaulta Stable Vault Shares",
            "vsUSD",
            IMorpho(morphoAddr),
            params,
            ownerAddr
        );

        vm.stopBroadcast();

        console.log("VaultaStableVault deployed at:", address(vault));
        console.log("Morpho:", morphoAddr);
        console.log("USDG:", usdgAddr);
        console.log("Owner:", ownerAddr);
    }
}
