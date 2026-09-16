#!/usr/bin/env bash
# Syntax/import smoke plus an optional Ollama connectivity check.
# A missing Ollama is an expected, clearly reported warning; it does not hide Python failures.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

HOST="${OLLAMA_HOST:-http://127.0.0.1:11434}"

if ! command -v python3 >/dev/null 2>&1; then
  echo "error: python3 is required for the smoke test" >&2
  exit 1
fi
if ! command -v curl >/dev/null 2>&1; then
  echo "error: curl is required for the smoke test" >&2
  exit 1
fi

echo "==> Syntax check"
python3 -m py_compile agent/config.py agent/ollama_client.py agent/tools.py agent/main.py eval/harness.py
echo "ok: py_compile"

echo "==> Imports"
PYTHONPATH="$ROOT" python3 -c "from agent.config import Config; c=Config.from_env(); print('host', c.host, 'model', c.model)"
echo "ok: agent/eval imports"

echo "==> Ollama availability"
if ! command -v ollama >/dev/null 2>&1; then
  echo "warn: Ollama is not installed or not on PATH; generation/eval are unavailable."
  echo "      Install from https://ollama.com/download, then run: ollama serve"
  echo "      Next: ./scripts/pull-model.sh"
elif curl -sf "${HOST}/api/tags" >/dev/null; then
  curl -s "${HOST}/api/tags" | python3 -c "import sys,json; d=json.load(sys.stdin); print('models:', [m.get('name') for m in d.get('models',[])][:8])"
else
  echo "warn: Ollama is installed but not reachable at $HOST."
  echo "      Start it with: ollama serve"
  echo "      Then pull a model with: ./scripts/pull-model.sh"
fi

echo "==> Smoke OK (syntax/import checks passed; Ollama connectivity is optional)"
