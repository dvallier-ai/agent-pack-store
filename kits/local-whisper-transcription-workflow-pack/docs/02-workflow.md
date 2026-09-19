# Day-to-day workflow

## Single file

```bash
bash scripts/transcribe.sh ~/Desktop/interview.m4a ~/transcripts/out
```

Outputs (same stem):

- `interview.txt` — raw text
- `interview.md` — titled markdown with source + timestamp

## Batch inbox

```bash
mkdir -p ~/transcripts/inbox ~/transcripts/out
# drop files into inbox, then:
bash scripts/batch_transcribe.sh ~/transcripts/inbox ~/transcripts/out
```

Already-transcribed stems (matching `.md` in out/) are skipped.

## Review pass (human)

1. Skim `.md` for speaker errors / proper nouns  
2. Fix names once; keep a tiny `glossary.txt` if you repeat clients  
3. Move audio → `archive/` when you’re happy  

## Optional: language / model

```bash
export WHISPER_LANG=en
export WHISPER_MODEL=small   # pip whisper model name
# or path to ggml for whisper.cpp
export WHISPER_MODEL=$HOME/models/ggml-small.en.bin
```

## Failure modes

| Symptom | Likely fix |
|---------|------------|
| `ffmpeg: not found` | brew/apt install ffmpeg |
| empty transcript | bad audio track; re-export wav 16k mono |
| OOM / fans scream | smaller model (`base` / `tiny`) |
| Metal slow first run | normal warmup; pin model on disk |
