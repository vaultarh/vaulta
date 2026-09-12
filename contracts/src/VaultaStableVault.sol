// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IMorpho, Market, MarketParams, MorphoMarketId} from "./interfaces/IMorpho.sol";

/// @title VaultaStableVault
/// @notice ERC-4626 vault that deposits USDG into a Morpho Blue market on Robinhood Chain.
///         This is a thin wrapper: all lending logic (interest accrual, liquidations,
///         collateral risk) is handled by Morpho Blue, which is already deployed and
///         audited independently of this contract. Vaulta does not reimplement lending.
///
/// @dev THIS CONTRACT HAS NOT BEEN AUDITED. Testnet / demo use only. Do not point this
///      at mainnet with real user funds before a professional audit.
contract VaultaStableVault is ERC4626, Ownable {
    using SafeERC20 for IERC20;
    using MorphoMarketId for MarketParams;

    IMorpho public immutable morpho;
    MarketParams public marketParams;
    bytes32 public immutable marketId;

    event MorphoSupplied(uint256 assets, uint256 sharesReceived);
    event MorphoWithdrawn(uint256 assets, uint256 sharesBurned);

    constructor(
        IERC20 _asset,
        string memory _name,
        string memory _symbol,
        IMorpho _morpho,
        MarketParams memory _marketParams,
        address _owner
    ) ERC4626(_asset) ERC20(_name, _symbol) Ownable(_owner) {
        require(_marketParams.loanToken == address(_asset), "market loanToken mismatch");
        morpho = _morpho;
        marketParams = _marketParams;
        marketId = _marketParams.id();

        // Approve Morpho once for max, standard pattern for immutable integrations.
        IERC20(_marketParams.loanToken).forceApprove(address(_morpho), type(uint256).max);
    }

    /// @notice Total USDG this vault has supplied to Morpho (assets under management).
    function totalAssets() public view override returns (uint256) {
        // Morpho tracks our position in shares; convert using the market's live exchange rate.
        Market memory m = morpho.market(marketId);
        uint256 ourShares = morpho.position(marketId, address(this)).supplyShares;
        if (m.totalSupplyShares == 0) return 0;
        return (ourShares * uint256(m.totalSupplyAssets)) / uint256(m.totalSupplyShares);
    }

    /// @dev After the base ERC4626 pulls `assets` of USDG from the depositor into this
    ///      vault, forward them into the Morpho market and mint vault shares to receiver.
    function _deposit(address caller, address receiver, uint256 assets, uint256 shares) internal override {
        super._deposit(caller, receiver, assets, shares);
        morpho.accrueInterest(marketParams);
        (uint256 suppliedAssets, uint256 suppliedShares) =
            morpho.supply(marketParams, assets, 0, address(this), "");
        emit MorphoSupplied(suppliedAssets, suppliedShares);
    }

    /// @dev Before the base ERC4626 sends `assets` of USDG to receiver, pull them back
    ///      out of the Morpho market first.
    function _withdraw(address caller, address receiver, address owner, uint256 assets, uint256 shares)
        internal
        override
    {
        morpho.accrueInterest(marketParams);
        (uint256 withdrawnAssets, uint256 withdrawnShares) =
            morpho.withdraw(marketParams, assets, 0, address(this), address(this));
        emit MorphoWithdrawn(withdrawnAssets, withdrawnShares);
        super._withdraw(caller, receiver, owner, assets, shares);
    }
}
