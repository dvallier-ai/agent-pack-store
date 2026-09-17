# Local-LLM Signal Drop

**SKU:** `local-llm-signal-drop` · **Version:** 0.1.0 · **Price:** $19 (draft / coming soon)

Weekly (or otherwise structured) **file drop** of local-LLM signal for engineers who already run models on their own iron: model and tool changelogs, rough VRAM tables, notable releases, and optional public market/odds citations as **data points only**.

This is **NOT financial advice** and **NOT a betting product**.

This is **not**:
- Betting advice, tips, or “bet this”
- A trading bot, Polymarket strategy, or financial product
- A substitute for reading primary release notes

If Polymarket prices, prediction-market odds, or similar figures appear in a drop, they are cited as **public data points** for context (attention / narrative heat). Never interpret them as recommendations to wager.

## What’s in this scaffold (v0.1.0)

| Path | Purpose |
|------|---------|
| `sample/2026-09-16-signal.md` | One sample drop (format Kit can ship) |
| `scripts/build-drop.sh` | Packs the sample into a versioned zip under `dist/` |
| `CHANGELOG.md` / `LICENSE` | Version history · MIT |

No Lemon checkout wired for this SKU yet. Status in the store catalog: `coming_soon` / `draft`.

## Drop format (intended)

Each drop is a single Markdown file (optionally zipped) with sections such as:

1. **Headline releases** — models / runtimes / tooling that matter for local inference
2. **VRAM / footprint notes** — ballpark tables (quant + context caveats)
3. **Tooling changelog** — Ollama, llama.cpp, vLLM, LM Studio, etc. (as relevant)
4. **Watchlist** — items worth reading primary sources on
5. **Public data (optional)** — odds/attention metrics labeled as data, not advice

## Build a sample zip

```bash
./scripts/build-drop.sh
# → dist/local-llm-signal-drop-v0.1.0.zip
```

## License

MIT — see `LICENSE`.
