# Agent Pack Store

Production MVP for curated, installable agent kits. Working name: **Agent Pack Store**.

## SKU #1 — Ollama Local Agent Kit

| Field | Value |
|-------|-------|
| Id | `ollama-local-agent-kit` |
| Title | Ollama Local Agent Kit |
| Price | $79 |
| Version | 0.1.0 |
| Checkout | Lemon test mode — https://twisted-relic.lemonsqueezy.com/checkout/buy/e84cbcae-1f17-418c-a309-83f6d7e7542e |

A reproducible local LLM agent setup for engineers: install scripts, Python agent skeleton talking to Ollama’s HTTP API, and an eval harness. Offline / local Ollama only.

## SKU — Local Biz Ops Kit

| Field | Value |
|-------|-------|
| Id | `local-biz-ops-kit` |
| Title | Local Biz Ops Kit |
| Price | $199 catalog (shelf $149–$299) |
| Version | 0.1.0 |
| Path | `kits/local-biz-ops-kit/` |

Agent-built ops pack for locksmith / home-services: booking request page, SMS templates, GBP post drafts, n8n stubs. Warm-buyer first; no cold spam tooling.

```bash
cd kits/local-biz-ops-kit
# preview booking page
cd booking && python3 -m http.server 8080
# package
bash scripts/package.sh
# → dist/local-biz-ops-kit-v0.1.0.zip
```

## Layout

```
agent-pack-store/
  README.md
  CHANGELOG.md
  catalog.json
  kits/ollama-local-agent-kit/
  kits/local-biz-ops-kit/       # home-services ops pack
  kits/local-llm-signal-drop/
  site/                          # static product landing
  scripts/package-kit.sh         # zip kit into dist/
  dist/                          # packaged zip(s)
```

## Quick start (kit)

```bash
cd kits/ollama-local-agent-kit
./install.sh
# or: python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
./scripts/pull-model.sh
./scripts/smoke.sh
./scripts/run-eval.sh
```

If Ollama is not installed, `install.sh` still sets up the Python environment and tells you what to install; `smoke.sh` checks syntax/imports and reports the missing Ollama step without attempting generation.

## Packaging

```bash
bash scripts/package-kit.sh
# → dist/ollama-local-agent-kit-v0.1.0.zip
```

## Site

Open `site/index.html` in a browser (file:// or any static host). Internal links use relative paths only.

Checkout is **Lemon Squeezy (Twisted Relic) in test mode** until Activate Store. Buy link: https://twisted-relic.lemonsqueezy.com/checkout/buy/e84cbcae-1f17-418c-a309-83f6d7e7542e

## Publish

- Keep `site/` as the source; from the repository root, refresh the Pages copy with `rm -rf docs && cp -R site docs`.
- In GitHub: **Settings → Pages → Deploy from a branch**, choose `main` and folder `/docs`, then **Save**.
- Repeat the copy after site changes; the static site has no build step.

## Catalog

See `catalog.json` for machine-readable SKU metadata.
