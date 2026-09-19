# Module 2 — Runner & API

**Goal:** Prove Ollama is reachable and that `/api/chat` returns content *before* you add tools.

## 1. Install & serve

Install from the official site: https://ollama.com/download  

Then:

```bash
ollama serve
# default API: http://127.0.0.1:11434
```

Keep `ollama` on your `PATH`. If the binary is missing, agent code will fail with connection errors that look like “loop bugs.”

## 2. Connectivity smoke

```bash
curl -s http://127.0.0.1:11434/api/tags
```

Expect JSON listing models (may be empty). Connection refused ⇒ serve is down or wrong host/port.

List / pull a **small** model for loop practice:

```bash
ollama list
ollama pull llama3.2:1b
# or another small instruct tag you already use
```

Record the exact tag you will use in `OLLAMA_MODEL`.

## 3. Minimal chat call

Ollama’s chat endpoint accepts messages with roles. Conceptually:

```text
POST /api/chat
{ "model": "<tag>", "messages": [ {"role":"system","content":"..."}, {"role":"user","content":"..."} ], "stream": false }
```

From a shell (adjust model tag):

```bash
curl -s http://127.0.0.1:11434/api/chat -d '{
  "model": "llama3.2:1b",
  "messages": [{"role":"user","content":"Reply with exactly: pong"}],
  "stream": false
}'
```

You should see a `message.content` field. If this fails, **do not** debug tool loops yet.

## 4. Env knobs that matter

Typical local-agent pattern (as used in the Ollama Local Agent Kit):

| Variable | Default idea | Notes |
|----------|--------------|-------|
| `OLLAMA_HOST` | `http://127.0.0.1:11434` | Must match serve bind |
| `OLLAMA_MODEL` | small instruct tag | Must appear in `ollama list` |
| `OLLAMA_TIMEOUT_SEC` | generous for CPU | Raise before blaming “hangs” |
| `AGENT_SYSTEM` | short role + rules | Keep stop rules here too |

Load overrides explicitly in the shell you run the agent from. A second terminal without the same env is a common “works in one window” trap.

## 5. Architecture sketch (mental model)

```text
┌─────────────┐     HTTP POST /api/chat      ┌──────────────┐
│  your loop  │ ───────────────────────────► │ Ollama       │
│  CLI / app  │ ◄─────────────────────────── │ :11434       │
└──────┬──────┘     message.content          │ + local model│
       │                                      └──────────────┘
       │ optional tool call
       ▼
┌─────────────┐
│ tool layer  │  allowlisted handlers only
└─────────────┘
```

Keep the HTTP client boring (stdlib or one HTTP library). Fancy streaming can wait until non-stream chat is stable.

## 6. Failure map (API layer)

| Symptom | Likely cause | First check |
|---------|--------------|-------------|
| Connection refused | `serve` down / wrong host | `curl …/api/tags` |
| Empty / weird model list | never pulled / wrong machine | `ollama list` |
| Timeout | CPU model + low timeout | raise timeout; smaller model |
| 404 / model not found | tag mismatch | pull exact tag |

## Done when

- [ ] `curl /api/tags` works on 127.0.0.1  
- [ ] One non-stream `/api/chat` returns text  
- [ ] `OLLAMA_HOST` + `OLLAMA_MODEL` documented  
- [ ] You can explain the diagram above without looking  

Next: Module 3 — tool-use loops.
