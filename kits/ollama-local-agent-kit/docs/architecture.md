# Architecture

```
┌─────────────┐     HTTP POST /api/chat      ┌──────────────┐
│  agent/main │ ───────────────────────────► │ Ollama       │
│  CLI / loop │ ◄─────────────────────────── │ :11434       │
└──────┬──────┘     JSON message.content     │ + local model│
       │                                      └──────────────┘
       │ optional /tool …
       ▼
┌─────────────┐
│ agent/tools │  stub handlers (echo, clock)
└─────────────┘

┌─────────────┐     same client               ┌──────────────┐
│ eval/harness│ ─────────────────────────────►│ Ollama       │
│ + fixtures  │ → report.json / report.md     └──────────────┘
└─────────────┘
```

## Components

- **`agent/config.py`** — env-based config (`OLLAMA_HOST`, `OLLAMA_MODEL`, `AGENT_SYSTEM`).
- **`agent/ollama_client.py`** — stdlib `urllib` client for `/api/chat` and `/api/tags`.
- **`agent/tools.py`** — optional local tool stub triggered by `/tool …` (extension point).
- **`agent/main.py`** — single-shot or `--chat` loop.
- **`eval/`** — fixtures + harness with latency / non-empty / keyword heuristics.

## Design choices

- Local-only: no cloud inference, no API keys required.
- Minimal deps: `requests` listed for convenience; client uses stdlib.
- Idempotent-ish install: safe to re-run; skips model pull if Ollama missing.
