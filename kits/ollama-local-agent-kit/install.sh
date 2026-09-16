#!/usr/bin/env bash
# Idempotent-ish installer for Ollama Local Agent Kit (macOS / Linux).
# Never hardcodes secrets. Does not install Ollama for you — documents how.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

DEFAULT_MODEL="${OLLAMA_MODEL:-llama3.2:1b}"
OLLAMA_HOST="${OLLAMA_HOST:-http://127.0.0.1:11434}"

echo "==> Ollama Local Agent Kit installer"
echo "    root: $ROOT"
echo "    host: $OLLAMA_HOST"
echo "    model: $DEFAULT_MODEL"
echo

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "error: required command not found: $1" >&2
    return 1
  fi
  echo "ok: found $1 ($(command -v "$1"))"
}

echo "-- Checking prerequisites --"
need_cmd curl || exit 1

if ! command -v ollama >/dev/null 2>&1; then
  echo
  echo "Ollama is not on PATH."
  echo "Install it, then re-run this script:"
  echo "  • macOS / Linux: https://ollama.com/download"
  echo "  • or: curl -fsSL https://ollama.com/install.sh | sh"
  echo "  • then start the daemon: ollama serve"
  echo
  echo "Continuing with Python deps only (model pull will be skipped)."
  SKIP_OLLAMA=1
else
  echo "ok: found ollama ($(command -v ollama))"
  SKIP_OLLAMA=0
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "error: python3 is required" >&2
  exit 1
fi
echo "ok: found python3 ($(python3 --version 2>&1))"

echo
echo "-- Python dependencies --"
if [[ "${APS_USE_VENV:-1}" == "1" ]]; then
  if [[ ! -d .venv ]]; then
    echo "Creating .venv ..."
    python3 -m venv .venv
  else
    echo "Using existing .venv"
  fi
  # shellcheck disable=SC1091
  source .venv/bin/activate
  pip install --upgrade pip >/dev/null
  pip install -r requirements.txt
  echo "Installed into .venv (activate with: source .venv/bin/activate)"
else
  echo "APS_USE_VENV=0 — install with: pip install -r requirements.txt"
  pip3 install -r requirements.txt || pip install -r requirements.txt
fi

if [[ ! -f .env ]]; then
  cp .env.example .env
  echo "Wrote .env from .env.example (edit if needed)"
else
  echo ".env already present — leaving unchanged"
fi

echo
echo "-- Ollama model --"
if [[ "$SKIP_OLLAMA" == "1" ]]; then
  echo "Skipped (Ollama not installed). After installing Ollama, run:"
  echo "  ./scripts/pull-model.sh"
else
  if curl -sf "${OLLAMA_HOST}/api/tags" >/dev/null 2>&1; then
    echo "Ollama API reachable at $OLLAMA_HOST"
    echo "Pulling default model: $DEFAULT_MODEL"
    ollama pull "$DEFAULT_MODEL" || {
      echo "warning: ollama pull failed — try: ./scripts/pull-model.sh" >&2
    }
  else
    echo "Ollama binary found but API not reachable at $OLLAMA_HOST"
    echo "Start it with: ollama serve"
    echo "Then: ./scripts/pull-model.sh"
  fi
fi

echo
if [[ "$SKIP_OLLAMA" == "1" ]]; then
  echo "Note: Python setup completed, but Ollama is still required for generation and eval."
  echo "Install it from https://ollama.com/download, then run: ollama serve"
fi

echo "==> Done."
echo "Next:"
echo "  source .venv/bin/activate   # if using venv"
echo "  set -a; source .env; set +a  # if you edited .env"
echo "  ./scripts/smoke.sh"
echo "  python -m agent.main --chat"
echo "  ./scripts/run-eval.sh"
