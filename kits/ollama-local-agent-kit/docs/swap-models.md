# Swapping models

Default model: `llama3.2:1b` (small, good for smoke tests).

## Change via environment

```bash
export OLLAMA_MODEL=llama3.2:3b
./scripts/pull-model.sh
python -m agent.main "Hello"
```

Or edit `.env` (copied from `.env.example`):

```
OLLAMA_MODEL=mistral:7b
```

## List local models

```bash
ollama list
```

## Eval with another model

```bash
OLLAMA_MODEL=phi3:mini ./scripts/run-eval.sh
```

## Notes

- Larger models need more RAM and higher `EVAL_MAX_LATENCY_SEC` / `OLLAMA_TIMEOUT_SEC`.
- Keyword heuristics in fixtures may fail if a model is very terse or verbose — adjust `eval/fixtures/prompts.json` as needed.
- This kit targets **local Ollama only**; remote OpenAI-compatible endpoints are an intentional non-goal for v0.1.0.
