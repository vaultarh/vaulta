// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IMorpho, Market, MarketParams, Position, MorphoMarketId} from "../../src/interfaces/IMorpho.sol";

/// @notice Minimal mock of Morpho Blue for vault unit tests. 1:1 shares, no interest
///         accrual simulation beyond an optional manual `simulateYield` bump — good
///         enough to prove the vault's supply/withdraw wiring is correct.
contract MockMorpho is IMorpho {
    using SafeERC20 for IERC20;
    using MorphoMarketId for MarketParams;

    mapping(bytes32 => Market) internal _markets;
    mapping(bytes32 => mapping(address => Position)) internal _positions;

    function supply(
        MarketParams memory marketParams,
        uint256 assets,
        uint256, /* shares */
        address onBehalf,
        bytes memory /* data */
    ) external returns (uint256, uint256) {
        bytes32 id = marketParams.id();
        IERC20(marketParams.loanToken).safeTransferFrom(msg.sender, address(this), assets);

        Market storage m = _markets[id];
        uint256 sharesToMint = m.totalSupplyShares == 0 ? assets : (assets * m.totalSupplyShares) / m.totalSupplyAssets;

        m.totalSupplyAssets += uint128(assets);
        m.totalSupplyShares += uint128(sharesToMint);
        _positions[id][onBehalf].supplyShares += sharesToMint;

        return (assets, sharesToMint);
    }

    function withdraw(
        MarketParams memory marketParams,
        uint256 assets,
        uint256, /* shares */
        address onBehalf,
        address receiver
    ) external returns (uint256, uint256) {
        bytes32 id = marketParams.id();
        Market storage m = _markets[id];
        uint256 sharesToBurn = (assets * m.totalSupplyShares) / m.totalSupplyAssets;

        m.totalSupplyAssets -= uint128(assets);
        m.totalSupplyShares -= uint128(sharesToBurn);
        _positions[id][onBehalf].supplyShares -= sharesToBurn;

        IERC20(marketParams.loanToken).safeTransfer(receiver, assets);
        return (assets, sharesToBurn);
    }

    function accrueInterest(MarketParams memory) external pure {
        // no-op for the mock; use simulateYield() to inject test yield instead
    }

    function position(bytes32 id, address user) external view returns (Position memory) {
        return _positions[id][user];
    }

    function market(bytes32 id) external view returns (Market memory) {
        return _markets[id];
    }

    /// @notice Test helper: simulate yield accruing in a market by minting extra
    ///         loanToken directly into this mock and bumping totalSupplyAssets,
    ///         without minting new shares (share price goes up, exactly like real yield).
    function simulateYield(MarketParams memory marketParams, uint256 yieldAmount) external {
        bytes32 id = marketParams.id();
        IERC20(marketParams.loanToken).safeTransferFrom(msg.sender, address(this), yieldAmount);
        _markets[id].totalSupplyAssets += uint128(yieldAmount);
    }
}
