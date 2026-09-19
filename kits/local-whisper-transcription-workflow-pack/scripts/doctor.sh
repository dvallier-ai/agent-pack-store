#!/usr/bin/env bash
# Check local Whisper transcription prerequisites.
set -euo pipefail

ok=0
warn=0

have() { command -v "$1" >/dev/null 2>&1; }

echo "== local-whisper doctor =="

if have ffmpeg; then
  echo "[ok] ffmpeg: $(ffmpeg -version 2>&1 | head -1)"
else
  echo "[missing] ffmpeg — brew install ffmpeg"
  ok=1
fi

found_whisper=0
for c in whisper-cli whisper main; do
  if have "$c"; then
    echo "[ok] whisper binary: $(command -v "$c")"
    found_whisper=1
    break
  fi
done

if have whisper && python3 -c "import whisper" 2>/dev/null; then
  echo "[ok] python openai-whisper importable"
  found_whisper=1
fi

if [[ "$found_whisper" -eq 0 ]]; then
  echo "[missing] no whisper-cli / whisper / whisper.cpp main on PATH"
  echo "         install whisper.cpp or: pip install openai-whisper"
  ok=1
fi

if [[ -n "${WHISPER_MODEL:-}" ]]; then
  if [[ -f "$WHISPER_MODEL" ]]; then
    echo "[ok] WHISPER_MODEL file: $WHISPER_MODEL"
  else
    echo "[info] WHISPER_MODEL=$WHISPER_MODEL (name or path — ensure it resolves for your CLI)"
    warn=1
  fi
else
  echo "[info] WHISPER_MODEL unset — pip whisper will use default; whisper.cpp needs a ggml path"
  warn=1
fi

echo "== done (exit $ok; warnings=$warn) =="
exit "$ok"
