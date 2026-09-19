# Module 4 — Failure modes

**Goal:** Recognize the usual ways local agent loops die — so you stop “randomly tweaking prompts” and start checking the right layer.

## Map: symptom → layer → first move

| Symptom | Likely layer | First move |
|---------|--------------|------------|
| Connection refused | Runner / API | `ollama serve`; `curl /api/tags` |
| Model not found | Runner | `ollama pull <exact-tag>`; fix `OLLAMA_MODEL` |
| Process killed / exit 137 / “out of memory” | Hardware / model size | Smaller quant; shorter context; fewer parallel loads |
| Slow then timeout | Runner + timeout config | Raise client timeout; smaller model; CPU expectation check |
| Tool runs forever | Loop control | Missing `MAX_TOOL_CALLS` / no wall clock |
| Same tool called repeatedly | Loop control / prompt | Detect duplicate calls; tighten system stop rules |
| Empty replies | Model / prompt / bug | Non-stream curl test; check temperature; log raw JSON |
| Works in terminal A, fails in B | Env | Compare `OLLAMA_*` and cwd |
| “Agent did nothing” | Parsing | Tool parse failed silently — log parse errors |

## 1. OOM / resource death

Common patterns:

- Model too large for RAM/VRAM  
- Context window stuffed with tool dumps  
- Multiple models loaded at once  
- Browser + IDE + model on a 16 GB laptop

Mitigations:

1. Drop to a smaller tag (practice loops on 1B–8B class).  
2. Cap observation size (truncate with a clear `…[truncated]` marker).  
3. Unload unused models (`ollama stop` / restart serve when stuck).  
4. Close other heavy apps during eval runs.

OOM is a **capacity** problem. Prompt poetry will not fix it.

## 2. API bind & reachability

From kit troubleshooting patterns:

```bash
ollama serve
curl -s http://127.0.0.1:11434/api/tags
```

If you changed bind address, set `OLLAMA_HOST` to match. Docker / WSL / remote-dev setups often point at the wrong localhost — confirm which machine actually runs `serve`.

## 3. Silent death loops

Definition: the process is alive, tokens may even stream, but progress toward the goal is zero.

Usual causes:

- No max turns  
- Model told to “keep trying” without a budget  
- Tool errors returned as empty strings  
- History never includes observations (tool ran but model never saw output)  
- Retry without backoff on the same failing call  

**Fix shape:** counters + structured observations + duplicate detection + hard deadline.

## 4. Flaky tool loops

- Exceptions swallowed → empty observation → model invents success  
- Relative paths resolving outside the project  
- Network tools without timeouts  
- Non-deterministic tools (live web) used in “evals”

Rule: every tool returns a string; every failure is an `ERR:` string; every call has a timeout.

## 5. Eval vs “it worked once”

A single interactive success is not a loop. Borrow the kit idea: a tiny fixture set with:

- Non-empty response  
- Latency under a threshold you set  
- Optional expected keyword  

If evals cannot run headlessly, you do not have a reproducible agent yet.

## 6. What not to do when stuck

- Pull a 70B “just to see” on a thin laptop  
- Disable stop limits “temporarily”  
- Expose Ollama to `0.0.0.0` to “make Docker easier” without auth  
- Paste production secrets into the prompt to “reproduce”

## Done when

- [ ] You can name which layer your last failure belonged to  
- [ ] You have reproduced at least one failure **on purpose** (e.g. wrong model tag) and fixed it  
- [ ] Your loop logs tool name, args hash, and observation length  

Next: Module 5 — debugging checklist.
