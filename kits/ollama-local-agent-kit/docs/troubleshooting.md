# Troubleshooting

## Ollama not found

Install from https://ollama.com/download or:

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Ensure `ollama` is on your `PATH`.

## Connection refused / cannot reach host

```bash
ollama serve
# default API: http://127.0.0.1:11434
curl -s http://127.0.0.1:11434/api/tags
```

Override with `OLLAMA_HOST` if you changed the bind address.

## Model missing

```bash
./scripts/pull-model.sh
# or: ollama pull llama3.2:1b
```

Set `OLLAMA_MODEL` to a model you already have (`ollama list`).

## Slow or timed-out evals

Increase limits:

```bash
export EVAL_MAX_LATENCY_SEC=60
export OLLAMA_TIMEOUT_SEC=180
./scripts/run-eval.sh
```

Smaller models (e.g. `llama3.2:1b`) are recommended for smoke/eval.

## Python import errors

Run from the kit root with `PYTHONPATH` set (scripts do this), or:

```bash
cd /path/to/ollama-local-agent-kit
source .venv/bin/activate
export PYTHONPATH=$PWD
python -m agent.main --chat
```

## py_compile / syntax

```bash
./scripts/smoke.sh
```
