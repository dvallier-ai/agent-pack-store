# Polymarket Research Pack

**SKU:** `polymarket-research-pack` · **Version:** 0.1.0 · **Price:** $19

Weekly-style **research brief** zip: top markets snapshot, odds-delta table (EXAMPLE when live scrape unavailable), and a sources list.

> **Research / education only.**  
> **NOT betting advice.**  
> **NOT a tip service.**  
> **NOT financial advice.**  
> **NOT a recommendation to bet.**

See **[DISCLOSURE.md](DISCLOSURE.md)** — the same disclosure must appear on every shipped pack page.

## What this is

| In scope | Out of scope |
|----------|--------------|
| Structured briefing of public prediction-market *topics* | Betting tips, tip-service picks, “bet this,” edge claims |
| Tables of snapshot / delta *format* (live or EXAMPLE) | Trading bots, order instructions |
| Source lists for further reading | Portfolio or bankroll advice |
| Education on how public odds pages are *read as data* | Wagering recommendations |

Empty-wallet / BTC pay rails on the store (`pay-btc.html?sku=polymarket-research-pack`) are **infra for buying this digital brief only** — not a trading stake.

## What’s included (v0.1.0)

| Path | Purpose |
|------|---------|
| `DISCLOSURE.md` | Bold legal/education disclosure (ship with every zip) |
| `sample/2026-09-18-pack.md` | One sample weekly-style issue |
| `scripts/build-pack.sh` | Builds versioned zip under `dist/` |
| `CHANGELOG.md` / `LICENSE` | Version history · MIT |

## Pack format (intended)

Each issue is Markdown (zipped) with:

1. **Disclosure banner** (required on every page)
2. **Top markets snapshot** — illustrative public-style framing
3. **Movers / odds deltas** — live if available; otherwise **EXAMPLE**-labeled
4. **Sources** — primary links to read, not to trade from
5. **Research notes** — questions to investigate; never “place order”

## Build the zip

```bash
./scripts/build-pack.sh
# → dist/polymarket-research-pack-v0.1.0.zip
```

## Buy (BTC manual fulfill)

- Pay page: store `docs/pay-btc.html?sku=polymarket-research-pack` (or `site/pay-btc.html?sku=…`)
- Address: `bc1q2csjux4ey8at6muk7zhheyhvad9e4hudsumlzg`
- Email proof to: **dvallier@gmail.com**

## License

MIT — see `LICENSE`.
