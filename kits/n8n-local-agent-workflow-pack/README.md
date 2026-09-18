# n8n Local Agent Workflow Pack

**SKU:** `n8n-local-agent-workflow-pack` · **Version:** 0.1.0 · **Price:** $39

Runnable **n8n workflow JSON stubs** for local-agent / Ollama / webhook patterns. Import into a self-hosted n8n, point at `localhost:11434`, and iterate.

## What’s included

| Path | Purpose |
|------|---------|
| `workflows/01-webhook-ollama-chat.json` | POST webhook → normalize → Ollama `/api/generate` → JSON response |
| `workflows/02-webhook-retry-dlq.json` | Event webhook → attempt gate → downstream → backoff retry → dead letter |
| `workflows/03-schedule-ollama-digest.json` | Daily schedule → Ollama digest → notify webhook |
| `docs/import-and-run.md` | Import steps, env vars, smoke checklist |
| `scripts/package.sh` | Builds `dist/n8n-local-agent-workflow-pack-v0.1.0.zip` |
| `LICENSE` / `CHANGELOG.md` | MIT · version history |

## Patterns (day-one)

1. **Chat bridge** — external tool hits n8n; Ollama answers offline.
2. **Retry + DLQ** — inspired by webhook hardening: classify fail, wait, bump attempt, dead-letter after 3.
3. **Scheduled digest** — local model drafts a daily stub digest you post elsewhere.

These are **stubs**: credentials, Error Workflow wiring, and real Slack/SMS nodes are left for you. No cloud LLM keys required for the default path.

## Requirements

- n8n (self-hosted / desktop)
- Ollama on `127.0.0.1:11434` with a small model (e.g. `llama3.2:1b`)
- Optional: env `DOWNSTREAM_URL`, `DLQ_WEBHOOK`, `DIGEST_WEBHOOK`

## Quick start

```bash
# 1. Import each JSON via n8n → Workflows → Import from File
# 2. Pull a model
ollama pull llama3.2:1b
# 3. Activate workflow 01, POST a test:
curl -sS -X POST "http://localhost:5678/webhook/local-agent-chat" \
  -H 'content-type: application/json' \
  -d '{"prompt":"Say hi in five words."}'
```

See `docs/import-and-run.md` for the full checklist.

## Package

```bash
bash scripts/package.sh
# → dist/n8n-local-agent-workflow-pack-v0.1.0.zip
```

## Buy (BTC / ETH manual fulfill)

- Pay: `docs/pay-btc.html?sku=n8n-local-agent-workflow-pack`
- BTC: `bc1q2csjux4ey8at6muk7zhheyhvad9e4hudsumlzg`
- ETH (mainnet): `0xcBd03b1BE83BBBCCaA3aE00166f4a57c377324E8`
- Email proof: **dvallier@gmail.com**

## License

MIT — see `LICENSE`.
