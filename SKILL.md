# VAULTA — Project Skill & Context Document

## What is Vaulta?

**Vaulta** is an **AI-driven, autonomous yield infrastructure protocol** built on [Robinhood Chain](https://chain.robinhood.com) (an EVM-compatible chain, chainId 4663).

**Core mechanic:** Users deposit USDG → receive `$vsUSD` (a yield-bearing stablecoin) → Vaulta's AI engine automatically allocates that capital across the highest risk-adjusted yield opportunities on Robinhood Chain — without requiring any manual action from the user.

Think of it as: **a self-managing yield account for on-chain capital.**

---

## What Problem Does Vaulta Solve?

Most on-chain capital is either:
- Sitting idle in wallets earning nothing
- Scattered across protocols requiring constant manual monitoring, rebalancing, and technical expertise

Accessing the best DeFi yields requires:
- Knowing which protocols are live (Morpho, Aerodrome, Ondo, etc.)
- Monitoring rates hourly
- Managing gas costs for rebalancing
- Understanding smart contract risk

**Vaulta abstracts all of this.** One deposit. Autonomous compounding. Full on-chain transparency.

---

## How It Works (Protocol Flow)

```
User deposits USDG
        ↓
Smart contract mints $vsUSD (1:1)
        ↓
AI Optimizer Engine evaluates:
  - APY rates across Morpho, Aerodrome, Ondo, Centrifuge, x402
  - Liquidity depth and counterparty risk
  - Gas efficiency of rebalancing
        ↓
Capital routes autonomously to best opportunity
        ↓
Yield compounds automatically into $vsUSD
        ↓
User redeems $vsUSD → receives USDG + yield, anytime
```

---

## Three Vault Products

| Vault | Risk | Target APY | Strategy |
|-------|------|------------|----------|
| **Stable Vault** | Low | 8–14% | Morpho lending + Aerodrome USDG/USDT LP |
| **Boost Vault** | Medium | 14–22% | RWA via Ondo (tokenized T-bills) + DeFi blend |
| **Alpha Vault** | High | 25–40% | Perp funding rates + BTCFi + x402 agentic flows |

---

## Technology Stack

### Smart Contracts
- Solidity ^0.8.20
- OpenZeppelin for ERC-20 ($vsUSD token)
- Custom vault architecture (non-custodial)
- Deployed on **Robinhood Chain** (mainnet target: Q3 2025)
- Testnet: **Robinhood Chain** (live now)

### AI Optimizer Engine
- Off-chain agent monitoring on-chain data
- Hourly rebalancing decisions
- Inputs: APY data, TVL depth, risk scores, gas prices
- Outputs: allocation weights per protocol
- All decisions recorded on-chain for auditability

### Protocol Integrations
- **Morpho** — lending market optimization
- **Aerodrome** — LP yield on Robinhood Chain
- **Ondo Finance** — tokenized RWA (T-bills, private credit)
- **Centrifuge** — institutional private credit
- **x402** — agentic commerce payment flows (2026 narrative)

---

## 2025–2026 Narrative Positioning

Based on the sector tier list:

| Tier | Sector | Vaulta Exposure |
|------|--------|----------------|
| S | Agentic Commerce | x402 integration in Alpha Vault |
| S | AI Finance | Core product identity — AI optimizer |
| S | Tokenization | $vsUSD token mechanics |
| A | RWA | Boost Vault via Ondo/Centrifuge |
| A | Stablecoins | $vsUSD yield-bearing stablecoin |
| A | Neobanks | UX positioning — "on-chain savings account" |
| B | x402 | Alpha Vault agentic payment flows |
| B | Perp Dex | Alpha Vault funding rate capture |
| B | BTCFi | Alpha Vault BTC yield strategies |
| B | Consumer DeFi | Core audience |
| B | TradFi Bridge | RWA/T-bill integration |

---

## $vsUSD Token

- **Type:** ERC-20 yield-bearing stablecoin
- **Peg:** 1 $vsUSD = 1 USDG (at deposit)
- **Yield:** Accrues continuously via rebasing mechanism
- **Redemption:** Anytime, no lock-up, no penalty
- **Composability:** Can be used in other DeFi protocols as collateral

---

## Roadmap

| Phase | Timeline | Milestone |
|-------|----------|-----------|
| Phase 1 | Q2 2025 | Testnet live (Robinhood Chain) — ACTIVE NOW |
| Phase 2 | Q3 2025 | Mainnet launch — Stable Vault. Target TVL: $500K |
| Phase 3 | Q4 2025 | Boost Vault + AI optimizer dashboard. Target: $5M TVL |
| Phase 4 | Q1 2027 | Alpha Vault + x402 + DAO governance. Target: $25M+ TVL |

---

## Design Language & Brand

- **Color palette:** Deep black (#050507), gold (#b89a46), muted warm white
- **Accent colors:** Green (#2ec97e) = yield/positive, Blue (#3d7de8) = protocol, Red (#c45c5c) = risk/alpha
- **Typography:** Bebas Neue (display/headings) + Space Mono (data/mono) + DM Sans (body)
- **Tone:** Institutional but accessible. Precise. No hype. Data-first.
- **NOT a meme project.** Positioned as serious infrastructure.

---

## Repository Structure

```
vaulta/
├── index.html              # Landing page (main)
├── app.html                # App/deposit interface
├── docs.html               # Documentation
├── SKILL.md                # This file — project context
├── README.md               # GitHub README
├── .github/
│   └── ISSUE_TEMPLATE.md
└── assets/
    └── og-image.png        # Social preview
```

---

## Key Differentiators vs Competitors

| | Vaulta | Yearn Finance | Beefy Finance | Manual DeFi |
|---|--------|---------------|---------------|-------------|
| AI-driven routing | ✅ | ❌ | ❌ | ❌ |
| Robinhood Chain-native | ✅ | ❌ | Partial | Varies |
| x402 agentic flows | ✅ | ❌ | ❌ | ❌ |
| RWA integration | ✅ | Limited | ❌ | Manual |
| $vsUSD composable token | ✅ | yvUSDG (similar) | mooBEEFY | ❌ |
| Testnet simulator | ✅ | ❌ | ❌ | N/A |

---

## Security Model

- **Non-custodial:** Vaulta never holds user keys
- **Smart contract audits:** Planned pre-mainnet (Certik / OpenZeppelin)
- **AI decisions on-chain:** All allocation changes are verifiable transactions
- **Emergency pause:** Multisig-controlled circuit breaker on all vaults
- **No admin mint:** $vsUSD cannot be minted without corresponding USDG deposit

---

## For AI Assistants Working on This Project

When building features, pages, or components for Vaulta:

1. **Always maintain the dark aesthetic** — no light mode, no white backgrounds
2. **Use the exact color variables** defined in `:root` — never hardcode hex values inline
3. **APY numbers are ranges, not guarantees** — label them "Target APY" or "Est. APY"
4. **Testnet = Robinhood Chain** — always clarify when something is testnet vs mainnet
5. **$vsUSD is always prefixed with $** — never write "vsUSD" without the dollar sign
6. **The CTA is never "Deploy Capital"** — it should be "Activate Capital", "Try Testnet", or "Enter App"
7. **Narrative anchors:** Always tie the product back to Agentic Commerce + AI Finance + RWA
8. **No promises of returns** — use projected/estimated language for all APY figures

---

*Last updated: 2025 · Vaulta Protocol · Built on Robinhood Chain*
