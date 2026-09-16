#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MODEL="${OLLAMA_MODEL:-llama3.2:1b}"
HOST="${OLLAMA_HOST:-http://127.0.0.1:11434}"

if ! command -v ollama >/dev/null 2>&1; then
  echo "error: ollama not on PATH. Install from https://ollama.com/download" >&2
  exit 1
fi

if ! curl -sf "${HOST}/api/tags" >/dev/null; then
  echo "error: Ollama API not reachable at $HOST — run: ollama serve" >&2
  exit 1
fi

echo "Pulling $MODEL ..."
ollama pull "$MODEL"
echo "Done."
