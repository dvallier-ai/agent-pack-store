# Ollama Local Agent Kit

**SKU:** `ollama-local-agent-kit` · **Version:** 0.1.0 · **Price:** $79

A reproducible, offline-first local LLM agent for engineers. Install scripts, a minimal Python agent that talks to Ollama’s HTTP API on `localhost:11434`, and an eval harness with fixtures and pass/fail reports.

This is **not** a prompt PDF pack — it is installable code.

## What’s included

| Path | Purpose |
|------|---------|
| `install.sh` | Checks curl/Ollama; documents install; optional venv; pulls default model |
| `agent/` | Chat loop + single-shot CLI; optional tool stub |
| `eval/` | Fixtures + harness → `report.json` + `report.md` |
| `scripts/` | `smoke.sh`, `pull-model.sh`, `run-eval.sh` |
| `docs/` | Architecture, troubleshooting, swapping models |
| `.env.example` | Config template (no secrets) |

## Prerequisites

- macOS or Linux
- `curl`
- [Ollama](https://ollama.com) installed and runnable (`ollama serve`)
- Python 3.10+ recommended

Ollama is required for model pulls, agent responses, and evals. On a machine without it, the installer can still create the Python environment; the smoke test will pass syntax/import checks and clearly report that Ollama is still needed.

## Install

```bash
./install.sh
```

Or manually:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env   # optional; defaults work for local Ollama
set -a; source .env; set +a  # load overrides into this shell, if you edited .env
./scripts/pull-model.sh
```

## Run the agent

```bash
# Single-shot
python -m agent.main "Explain what a local LLM agent is in one paragraph."

# Interactive chat
python -m agent.main --chat
```

Environment (see `.env.example`):

- `OLLAMA_HOST` — default `http://127.0.0.1:11434`
- `OLLAMA_MODEL` — default `llama3.2:1b`
- `AGENT_SYSTEM` — optional system prompt override

## Eval

```bash
./scripts/run-eval.sh
# writes eval/report.json and eval/report.md
```

Eval requires a running Ollama server and the selected model. If Ollama is missing or stopped, the runner exits nonzero, explains the install/start steps, and writes a failed report. Heuristics: non-empty response, latency under threshold, optional expected keyword.

## Smoke test

```bash
./scripts/smoke.sh
```

Smoke does not require Ollama to verify syntax/imports. Without Ollama it exits successfully with a warning; install Ollama from <https://ollama.com/download>, run `ollama serve`, pull the model with `./scripts/pull-model.sh`, then rerun smoke for the connectivity check.

## License

MIT — see `LICENSE`.
