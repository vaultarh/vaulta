// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {VaultaStableVault} from "../src/VaultaStableVault.sol";
import {IMorpho, MarketParams} from "../src/interfaces/IMorpho.sol";
import {MockMorpho} from "./mocks/MockMorpho.sol";

contract MockUSDG is ERC20 {
    constructor() ERC20("Mock USDG", "USDG") {}
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract VaultaStableVaultTest is Test {
    MockUSDG usdg;
    MockMorpho morpho;
    VaultaStableVault vault;
    MarketParams params;

    address owner = address(0xA11CE);
    address alice = address(0xA1);
    address bob = address(0xB0B);

    function setUp() public {
        usdg = new MockUSDG();
        morpho = new MockMorpho();

        params = MarketParams({
            loanToken: address(usdg),
            collateralToken: address(0xC01), // mock USDe collateral, unused by mock logic
            oracle: address(0xFEED),
            irm: address(0x1204),
            lltv: 915000000000000000
        });

        vault = new VaultaStableVault(
            IERC20(address(usdg)),
            "Vaulta Stable Vault Shares",
            "vsUSD",
            IMorpho(address(morpho)),
            params,
            owner
        );

        usdg.mint(alice, 1_000e18);
        usdg.mint(bob, 1_000e18);

        vm.prank(alice);
        usdg.approve(address(vault), type(uint256).max);
        vm.prank(bob);
        usdg.approve(address(vault), type(uint256).max);
    }

    function test_metadata() public view {
        assertEq(vault.name(), "Vaulta Stable Vault Shares");
        assertEq(vault.symbol(), "vsUSD");
        assertEq(vault.asset(), address(usdg));
        assertEq(vault.owner(), owner);
    }

    function test_depositRoutesToMorpho() public {
        vm.prank(alice);
        uint256 shares = vault.deposit(100e18, alice);

        // 1:1 on first deposit
        assertEq(shares, 100e18);
        assertEq(vault.balanceOf(alice), 100e18);
        assertEq(vault.totalAssets(), 100e18);

        // USDG actually left alice's wallet and is now inside Morpho (mock), not sitting idle in the vault
        assertEq(usdg.balanceOf(alice), 900e18);
        assertEq(usdg.balanceOf(address(vault)), 0);
        assertEq(usdg.balanceOf(address(morpho)), 100e18);
    }

    function test_withdrawPullsFromMorpho() public {
        vm.prank(alice);
        vault.deposit(100e18, alice);

        vm.prank(alice);
        uint256 shares = vault.withdraw(40e18, alice, alice);

        assertEq(shares, 40e18);
        assertEq(usdg.balanceOf(alice), 940e18);
        assertEq(vault.totalAssets(), 60e18);
        assertEq(usdg.balanceOf(address(morpho)), 60e18);
    }

    function test_yieldAccruesToAllDepositorsProRata() public {
        vm.prank(alice);
        vault.deposit(100e18, alice);
        vm.prank(bob);
        vault.deposit(100e18, bob);
        uint256 aliceShares = vault.balanceOf(alice);

        // Simulate 20 USDG of yield landing in the Morpho market (e.g. borrower interest)
        usdg.mint(address(this), 20e18);
        usdg.approve(address(morpho), 20e18);
        morpho.simulateYield(params, 20e18);
        // Vault's total assets under management should reflect the yield
        assertEq(vault.totalAssets(), 220e18);

        // Alice and Bob each supplied 50% of shares, so each can now redeem ~110 USDG
        uint256 aliceMaxWithdraw = vault.maxWithdraw(alice);
        uint256 bobMaxWithdraw = vault.maxWithdraw(bob);
        assertApproxEqAbs(aliceMaxWithdraw, 110e18, 1);
        assertApproxEqAbs(bobMaxWithdraw, 110e18, 1);

        vm.prank(alice);
        vault.redeem(aliceShares, alice, alice);
        assertApproxEqAbs(usdg.balanceOf(alice), 1010e18, 1);
    }

    function test_secondDepositorEntersAtCorrectShareValue() public {
        vm.prank(alice);
        vault.deposit(100e18, alice);

        // Yield accrues before Bob joins
        usdg.mint(address(this), 100e18);
        usdg.approve(address(morpho), 100e18);
        morpho.simulateYield(params, 100e18);

        // Vault now worth 200 USDG for 100 shares -> share price = 2 USDG/share
        vm.prank(bob);
        uint256 bobShares = vault.deposit(100e18, bob);

        // Bob should get ~50 shares for his 100 USDG (buying in at the higher price),
        // not 100 shares — otherwise Alice's earned yield would be diluted away.
        assertApproxEqAbs(bobShares, 50e18, 1);
    }

    function test_revertsOnMarketTokenMismatch() public {
        MarketParams memory badParams = params;
        badParams.loanToken = address(0xBAD);

        vm.expectRevert(bytes("market loanToken mismatch"));
        new VaultaStableVault(
            IERC20(address(usdg)),
            "Bad Vault",
            "bad",
            IMorpho(address(morpho)),
            badParams,
            owner
        );
    }
}
