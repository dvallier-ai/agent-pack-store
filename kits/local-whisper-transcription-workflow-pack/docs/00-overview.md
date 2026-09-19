# Overview — local Whisper workflow

Goal: **audio on disk → transcript markdown**, without a paid cloud STT bill.

## Why local

- Meeting notes, interview dumps, voice memos stay on your laptop
- Predictable cost (electricity + time), no per-minute meters
- Works offline / flaky wifi — HN-friendly dogfood story

## Two common local stacks

| Stack | Pros | Cons |
|-------|------|------|
| **whisper.cpp** | Fast C++ , Metal on Mac, small CLIs | You manage model files |
| **openai-whisper (pip)** | Simple `whisper file.mp3` | Heavier Python/torch install |

Either is fine. `scripts/transcribe.sh` auto-detects `whisper-cli`, `whisper.cpp` `main`, or pip `whisper`.

## Suggested folder layout

```
~/transcripts/
  inbox/     # drop m4a/mp3/wav/webm
  out/       # .txt + .md land here
  archive/   # move processed audio when done
```

## Privacy baseline

- Don’t drop client audio into random cloud “free” UIs
- Strip filenames that contain secrets before sharing samples
- Treat transcripts as sensitive as the audio
