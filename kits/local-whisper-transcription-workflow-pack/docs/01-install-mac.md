# Install notes (Mac-first, Linux OK)

## 1. ffmpeg

```bash
brew install ffmpeg
# Linux: apt install ffmpeg / dnf install ffmpeg
ffmpeg -version
```

## 2a. whisper.cpp (recommended on Apple Silicon)

```bash
brew install whisper-cpp
# or build from https://github.com/ggerganov/whisper.cpp
which whisper-cli || which main
```

Download a model (example: base.en) into a models dir and export:

```bash
export WHISPER_MODEL="$HOME/models/ggml-base.en.bin"
export WHISPER_BIN="$(command -v whisper-cli || true)"
```

## 2b. pip openai-whisper (local weights)

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -U openai-whisper
whisper --help
```

First run downloads weights into the Whisper cache — still local, not the paid API.

## 3. Doctor

```bash
bash scripts/doctor.sh
```

Fix anything it flags before batch jobs.
