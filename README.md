# VAULTA — Autonomous Yield Infrastructure on Robinhood Chain

> Deposit USDG. Receive $vsUSD. Let AI compound your capital — 24/7, on-chain, transparent.

[![Built on Robinhood Chain](https://img.shields.io/badge/Built_on-Robinhood_Chain-000000?style=flat-square)](https://chain.robinhood.com)
[![Status](https://img.shields.io/badge/Status-Mainnet_Live-brightgreen?style=flat-square)]()
[![License](https://img.shields.io/badge/License-MIT-gold?style=flat-square)](LICENSE)

**Contract Address:** `0x7117dB2D6590309463f278bC550719a36667C26f`
[View on Robinhood Chain Explorer](https://robinhoodchain.blockscout.com/address/0x7117dB2D6590309463f278bC550719a36667C26f)

---

## What is Vaulta?

Vaulta is a **non-custodial, AI-driven yield protocol** on Robinhood Chain. Users deposit USDG into one of three vaults, receive the yield-bearing `$vsUSD` token, and earn optimized returns — automatically — without managing positions, monitoring rates, or paying excessive gas.

The AI optimizer routes capital across lending, real-world assets, perp funding, and x402 agentic flows — continuously rebalancing toward the highest risk-adjusted opportunity.

---

## Protocol Architecture

```
User -> USDG Deposit
         |
    Vault Contract
         |
    $vsUSD Minted (1:1)
         |
    AI Optimizer Engine
    +--------------------+
    |  Lending markets   |
    |  LP / DEX          |
    |  RWA / T-bill      |
    |  Credit markets    |
    |  x402 (agentic)    |
    +--------------------+
         |
    Yield Compounds -> $vsUSD appreciates
         |
    User redeems anytime -> USDG + yield
```

---

## Vault Products

| Vault | Risk | Est. APY | Primary Strategies |
|-------|------|----------|--------------------|
| **Stable Vault** | Low | 8-14% | USDG lending + tight-range LP |
| **Boost Vault** | Medium | 14-22% | RWA + DeFi blend |
| **Alpha Vault** | High | 25-40% | Perp funding, x402 agentic flows |

> APY figures are estimates based on current protocol conditions. Not financial advice. Past performance does not guarantee future results.

---

## 2026-2027 Narrative Positioning

Vaulta sits at the intersection of the strongest on-chain narratives:

- **S-tier:** Agentic Commerce (x402), AI Finance, Tokenization
- **A-tier:** RWA, Stablecoins, Neobanks
- **B-tier:** Perp Dex, Consumer DeFi

---

## Repository Structure

```
vaulta/
├── index.html          # Main landing page
├── app.html            # App / deposit interface
├── docs.html           # Documentation page
├── SKILL.md            # Full project context & design system
└── README.md           # This file
```

---

## Local Development

No build step required. Pure HTML/CSS/JS.

```bash
# Clone the repo
git clone https://github.com/vaultarh/vaulta.git

# Open locally
cd vaulta
open index.html

# Or serve with any static server
npx serve .
# -> http://localhost:3000
```

---

## Roadmap

| Phase | Timeline | Status |
|-------|----------|--------|
| Mainnet Deploy (Robinhood Chain) | Q2 2026 | Live |
| Token + Contract Launch | Q3 2026 | Live |
| Smart Contract Audit | Q3 2026 | In Progress |
| Boost Vault + AI Dashboard | Q4 2026 | Upcoming |
| Alpha Vault + x402 + DAO | Q1 2027 | Planned |

---

## Tech Stack

- **Chain:** Robinhood Chain (chainId 4663)
- **Contracts:** Solidity ^0.8.20 + OpenZeppelin
- **Frontend:** Vanilla HTML/CSS/JS (no framework dependency)
- **Fonts:** Bebas Neue, Space Mono, DM Sans (Google Fonts)
- **Integrations:** x402 agentic flows, on-chain lending/RWA protocols

---

## Security

- Non-custodial architecture — users retain key control
- Emergency pause via multisig circuit breaker
- All AI allocation decisions recorded on-chain
- No admin mint function — $vsUSD only minted 1:1 with USDG
- Audit planned pre-mainnet

---

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit changes (`git commit -m 'feat: add feature'`)
4. Push to branch (`git push origin feature/your-feature`)
5. Open a Pull Request

See [SKILL.md](./SKILL.md) for full design system and project context before contributing.

**Contract Address:** `0x7117dB2D6590309463f278bC550719a36667C26f`

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

*Built on Robinhood Chain · Powered by AI · Non-custodial*
