#!/usr/bin/env bash
# Transcribe one audio file → out_dir/<stem>.txt + <stem>.md
# Usage: bash scripts/transcribe.sh <audio> [out_dir]
set -euo pipefail

usage() { echo "Usage: $0 <audio-file> [out_dir]" >&2; exit 2; }
[[ $# -ge 1 ]] || usage

AUDIO="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
OUT_DIR="${2:-./out}"
mkdir -p "$OUT_DIR"

[[ -f "$AUDIO" ]] || { echo "error: not a file: $AUDIO" >&2; exit 1; }

STEM="$(basename "$AUDIO")"
STEM="${STEM%.*}"
TXT="$OUT_DIR/$STEM.txt"
MD="$OUT_DIR/$STEM.md"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

have() { command -v "$1" >/dev/null 2>&1; }

LANG_CODE="${WHISPER_LANG:-en}"
MODEL="${WHISPER_MODEL:-base}"

run_whisper_cpp() {
  local bin="$1"
  local model_path="${WHISPER_MODEL:-}"
  if [[ -z "$model_path" || ! -f "$model_path" ]]; then
    echo "error: whisper.cpp needs WHISPER_MODEL=/path/to/ggml-*.bin" >&2
    exit 1
  fi
  # Convert to 16k wav for broader compatibility
  local wav="$TMP/input.wav"
  ffmpeg -y -i "$AUDIO" -ar 16000 -ac 1 "$wav" >/dev/null 2>&1
  "$bin" -m "$model_path" -f "$wav" -l "$LANG_CODE" -otxt -of "$TMP/out" >/dev/null
  if [[ -f "$TMP/out.txt" ]]; then
    cp "$TMP/out.txt" "$TXT"
  else
    # some builds print to stdout only
    "$bin" -m "$model_path" -f "$wav" -l "$LANG_CODE" > "$TXT"
  fi
}

run_pip_whisper() {
  local args=(--output_dir "$TMP" --output_format txt --language "$LANG_CODE")
  if [[ -n "${WHISPER_MODEL:-}" && ! -f "${WHISPER_MODEL}" ]]; then
    args+=(--model "$WHISPER_MODEL")
  elif [[ -z "${WHISPER_MODEL:-}" ]]; then
    args+=(--model base)
  else
    args+=(--model base)
  fi
  whisper "$AUDIO" "${args[@]}"
  # openai-whisper names output after stem in output_dir
  local produced
  produced="$(find "$TMP" -type f -name '*.txt' | head -1)"
  [[ -n "$produced" ]] || { echo "error: whisper produced no txt" >&2; exit 1; }
  cp "$produced" "$TXT"
}

if [[ -n "${WHISPER_BIN:-}" && -x "${WHISPER_BIN}" ]]; then
  run_whisper_cpp "$WHISPER_BIN"
elif have whisper-cli; then
  run_whisper_cpp "$(command -v whisper-cli)"
elif have main && [[ -n "${WHISPER_MODEL:-}" && -f "${WHISPER_MODEL}" ]]; then
  run_whisper_cpp "$(command -v main)"
elif have whisper; then
  run_pip_whisper
else
  echo "error: no whisper binary found. Run scripts/doctor.sh" >&2
  exit 1
fi

TS="$(date '+%Y-%m-%d %H:%M %Z')"
{
  echo "# Transcript: $STEM"
  echo
  echo "- Source: \`$(basename "$AUDIO")\`"
  echo "- Generated: $TS"
  echo "- Lang: $LANG_CODE"
  echo
  echo "## Text"
  echo
  cat "$TXT"
} > "$MD"

echo "Wrote $TXT"
echo "Wrote $MD"
