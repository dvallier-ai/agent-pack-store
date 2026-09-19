# Module 1 — Setup boundaries

**Goal:** Decide what your local agent may touch *before* you wire tools. Most silent disasters start as “I’ll harden later.”

## 1. Hardware reality (write it down)

Copy this into a notes file:

- OS / version:  
- CPU / GPU / VRAM / RAM:  
- Free disk for models:  
- Primary machine (one box day one):  

**Practical floors** (same spirit as the free Local-LLM checklist):

- Prefer **≥16 GB RAM** for small instruct models; 32 GB is more comfortable for 7–13B Q4/Q5 class.  
- Free **≥40 GB** disk if you will pull more than one model family.  
- CPU-only is fine for learning loops; do not buy a GPU to “fix” a bad stop condition.

If your goal is a reliable **bounded** agent loop, start with a **small** instruct model. Bigger models amplify OOM and timeout failure modes.

## 2. Privacy & data classes

Decide up front what may enter the prompt or tool outputs:

| Class | Local Ollama default | Rule of thumb |
|-------|----------------------|---------------|
| Public docs / your own notes | OK | Prefer folders you own |
| Client PII, health, bank, passwords | High risk | Keep out of prompts; never in tool args |
| Secrets / API keys / wallet seeds | Forbidden | Never paste; never log |

Even on localhost: logs, chat history files, and crash dumps can retain secrets. Treat disk like a shared clipboard.

## 3. Network bind (non-negotiable day one)

- Bind the runner to **`127.0.0.1` only** until you have a real need for LAN.  
- Do **not** expose `:11434` (or your agent port) to the public internet.  
- If you later need LAN: reverse proxy + auth; never “just open the port.”

Override host only when you mean it (e.g. `OLLAMA_HOST=http://127.0.0.1:11434`).

## 4. Tool boundaries (policy before code)

Write a one-page tool policy:

1. **Allowed tools** (start with 0–2: e.g. clock, echo, read-from-one-folder).  
2. **Denied tools** (shell as root, arbitrary HTTP, wallet/signing, delete-anything).  
3. **Working directory** — one project root; no `../` escapes.  
4. **Max tool calls per turn** (e.g. 3) and **max turns per run** (e.g. 8).  
5. **Stop conditions** — success criteria, empty observation, repeated tool name, timeout.

If you cannot state stop conditions in one sentence, you do not have an agent loop yet — you have a chat that sometimes calls functions.

## 5. Reproducibility stub

Before debugging loops, capture:

```text
date
uname -a
ollama --version   # if installed
ollama list        # if installed
echo "OLLAMA_HOST=${OLLAMA_HOST:-unset}"
echo "OLLAMA_MODEL=${OLLAMA_MODEL:-unset}"
```

Save the output next to your project. Future-you (and any async auditor) needs a repro baseline.

## Done when

- [ ] Hardware notes exist  
- [ ] Data classes decided  
- [ ] Bind is localhost-only  
- [ ] Tool allowlist + stop limits written  
- [ ] Version/`ollama list` snapshot saved  

Next: Module 2 — runner & API.
