# vaulta-contracts

Smart contracts for **Vaulta** — an ERC-4626 vault on Robinhood Chain that routes
USDG deposits into a Morpho Blue lending market, instead of reimplementing lending
logic from scratch.

## Status: soft-launch, mainnet, small amounts only. NOT AUDITED.

`VaultaStableVault` is deployed and live on Robinhood Chain mainnet:

| | |
|---|---|
| Vault | [`0x89641dD36b296Da16B28cdc4bFe06cE4c8f5D5Ff`](https://robinhoodchain.blockscout.com/address/0x89641dD36b296Da16B28cdc4bFe06cE4c8f5D5Ff) |
| Chain | Robinhood Chain, chainId `4663` |
| Underlying asset | USDG — [`0x5fc5360D0400a0Fd4f2af552ADD042D716F1d168`](https://robinhoodchain.blockscout.com/address/0x5fc5360D0400a0Fd4f2af552ADD042D716F1d168) |
| Vault share token | `$vsUSD` |
| Yield source | Morpho Blue, USDG/USDe market — [`0x9D53d5E3bd5E8d4Cbfa6DB1ca238AEA02E651010`](https://robinhoodchain.blockscout.com/address/0x9D53d5E3bd5E8d4Cbfa6DB1ca238AEA02E651010) |
| Market TVL (at integration time) | ~$315M, supply APY ~3.6% (live, not fixed — reflects Morpho market conditions) |

**This has NOT been through a professional security audit.** It is currently being
used only by the project owner, with small amounts, as a live rehearsal before any
public launch or third-party deposits. Do not point a production frontend at this
address for public users before an audit.

## How it works

```
User deposits USDG
        |
        v
VaultaStableVault (ERC-4626, this repo)
        |
        v
Morpho Blue . supply(marketParams, ...)   <-- USDG/USDe market, audited independently
        |
        v
Interest accrues on-chain, vault share price rises
        |
        v
User redeems $vsUSD -> USDG + yield, any time
```

The vault does not implement its own lending, liquidation, or interest-rate logic.
All of that lives in Morpho Blue, which is deployed and used independently by
Robinhood's own "Robinhood Earn" product. This contract is a thin, auditable
wrapper: it forwards deposits in, forwards withdrawals out, and reports
`totalAssets()` by reading the vault's live position from Morpho.

## Contracts

| File | Purpose |
|---|---|
| `src/VaultaStableVault.sol` | ERC-4626 vault wrapper around a single Morpho Blue market |
| `src/interfaces/IMorpho.sol` | Minimal Morpho Blue interface + market-id hashing (matches Morpho's on-chain encoding, verified against a live market) |
| `script/DeployTestnet.s.sol` | Deployment script (name kept for history; it deploys to whichever `--rpc-url` you pass — mainnet in this case, since Morpho is not deployed on Robinhood Chain testnet, see below) |
| `test/VaultaStableVault.t.sol` | Foundry unit tests against a mock Morpho, incl. multi-depositor yield accounting |
| `test/mocks/MockMorpho.sol` | Minimal Morpho mock used only for tests |

## Why mainnet and not testnet

Robinhood Chain testnet (chainId `46630`) does not have Morpho Blue or USDG
deployed on it — verified directly via `eth_getCode` (returns `0x` for both) and
confirmed independently by third-party tooling. Testnet is a bare EVM sandbox for
contract deployment only; none of the DeFi ecosystem (Morpho, Uniswap, USDG) exists
there. That is why this vault was rehearsed on mainnet directly, with a small
amount of the owner's own funds, rather than on testnet.

## Verifying the market wiring yourself

The vault is wired to one specific Morpho Blue market (USDG supplied, USDe as
collateral). You can independently recompute the market id and confirm it exists:

```bash
cast keccak "$(cast abi-encode 'f(address,address,address,address,uint256)' \
  0x5fc5360D0400a0Fd4f2af552ADD042D716F1d168 \
  0x5d3a1Ff2b6BAb83b63cd9AD0787074081a52ef34 \
  0xE64849bd4AD03DfaBbe02bb521de19997a19055f \
  0x2BD3d5965B26B51814AC95127B2b80dD6CcC0fa1 \
  915000000000000000)"
# -> 0xc845da65a020ddca5f132efa8fea79676d8edfdea504226a4c01e7a9e34cddd6

cast call 0x9D53d5E3bd5E8d4Cbfa6DB1ca238AEA02E651010 \
  "market(bytes32)(uint128,uint128,uint128,uint128,uint128,uint128)" \
  0xc845da65a020ddca5f132efa8fea79676d8edfdea504226a4c01e7a9e34cddd6 \
  --rpc-url https://rpc.mainnet.chain.robinhood.com
```

## Development

```bash
forge install
forge build
forge test -vv
```

6 tests currently pass, covering: deposit routing to Morpho, withdraw pulling
from Morpho, pro-rata yield accounting across multiple depositors, correct share
pricing for a depositor entering after yield has accrued, and a revert guard on
misconfigured market params.

## Roadmap before any public / audited launch

- [ ] Third-party security audit
- [ ] Reentrancy guard review (Morpho Blue's `supply`/`withdraw` are external calls
      inside `_deposit`/`_withdraw` — currently relying on Morpho Blue's own
      reentrancy protections and checks-effects-interactions ordering; an audit
      should confirm this is sufficient)
- [ ] Pause / emergency-exit mechanism
- [ ] Frontend rewiring: replace all dummy dashboard data with live reads from this
      contract and from Morpho's market state
- [ ] Boost / Alpha vaults (other Morpho markets, or other strategies) — later phase,
      not started
