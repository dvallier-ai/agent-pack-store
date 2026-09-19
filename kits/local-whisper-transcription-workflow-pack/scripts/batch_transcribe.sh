#!/usr/bin/env bash
# Batch-transcribe audio files in inbox_dir → out_dir (skips if .md exists).
# Usage: bash scripts/batch_transcribe.sh <inbox_dir> [out_dir]
set -euo pipefail

usage() { echo "Usage: $0 <inbox_dir> [out_dir]" >&2; exit 2; }
[[ $# -ge 1 ]] || usage

INBOX="$1"
OUT="${2:-./out}"
mkdir -p "$OUT"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
shopt -s nullglob

count=0
skip=0
for f in "$INBOX"/*.{mp3,m4a,wav,webm,ogg,flac,MP3,M4A,WAV}; do
  [[ -f "$f" ]] || continue
  stem="$(basename "$f")"
  stem="${stem%.*}"
  if [[ -f "$OUT/$stem.md" ]]; then
    echo "[skip] $stem.md exists"
    skip=$((skip + 1))
    continue
  fi
  echo "[run] $f"
  bash "$SCRIPT_DIR/transcribe.sh" "$f" "$OUT"
  count=$((count + 1))
done

echo "Done. transcribed=$count skipped=$skip out=$OUT"
