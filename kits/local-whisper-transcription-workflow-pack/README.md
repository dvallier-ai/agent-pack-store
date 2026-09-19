# Local Whisper Transcription Workflow Pack v0.1

**SKU:** `local-whisper-transcription-workflow-pack` · **Version:** 0.1.0 · **Price:** $29  
**Audience:** Indie / HN-native builders who want **local** speech→text without paid cloud STT

Dogfoods **Mac + local** paths. No OpenAI Whisper API key required for the default route.

**Read `DISCLAIMER.md` first.** Scripts + docs are education / starter workflow — you own model licenses, hardware, and privacy choices.

---

## What’s inside

| Path | Purpose |
|------|---------|
| `DISCLAIMER.md` | Education only; no cloud SLA; privacy on you |
| `docs/00-overview.md` | Why local Whisper, Mac/Linux notes |
| `docs/01-install-mac.md` | brew / pip / whisper.cpp vs openai-whisper |
| `docs/02-workflow.md` | Folder drop → transcribe → review markdown |
| `docs/03-hn-dogfood-notes.md` | Indie launch / dogfood checklist (no Reddit) |
| `scripts/transcribe.sh` | Bash wrapper: file in → `.txt` + `.md` out |
| `scripts/batch_transcribe.sh` | Folder batch with skip-if-done |
| `scripts/doctor.sh` | Check ffmpeg + whisper binary availability |
| `samples/README.md` | Where to drop a short test clip |
| `LICENSE` / `CHANGELOG.md` | MIT · history |

## Requirements (default path)

- macOS or Linux
- `ffmpeg` on PATH
- One of:
  - [`whisper.cpp`](https://github.com/ggerganov/whisper.cpp) (`main` / `whisper-cli`) **or**
  - `openai-whisper` via `pip` (`whisper` CLI) — still **local** weights, not the paid API
- Disk for model weights (start with `base` or `small`)

## Quick start

```bash
# 1. Sanity
bash scripts/doctor.sh

# 2. One file (set WHISPER_BIN if needed)
bash scripts/transcribe.sh /path/to/clip.m4a ./out

# 3. Batch a folder
bash scripts/batch_transcribe.sh ./inbox ./out
```

See `docs/02-workflow.md` for the inbox/outbox layout indie operators actually keep.

## What’s NOT included

- Paid cloud STT accounts (Deepgram, AssemblyAI, OpenAI API, etc.)
- Guaranteed WER / accuracy claims
- Auto-publish to YouTube/podcast hosts
- Any face/brand kit assets

## Buy (BTC / ETH manual fulfill)

- Pay: `docs/pay-btc.html?sku=local-whisper-transcription-workflow-pack`
- BTC: `bc1q2csjux4ey8at6muk7zhheyhvad9e4hudsumlzg`
- ETH (mainnet): `0xcBd03b1BE83BBBCCaA3aE00166f4a57c377324E8`
- Email proof: **dvallier@gmail.com**

## License

MIT for pack scripts/docs. Whisper model weights and whisper.cpp remain under their upstream licenses.

---
*Local Whisper Transcription Workflow Pack v0.1 · Passive Engine · 2026-09-19 PT*
