# Module 3 — Tool-use loops

**Goal:** Implement (or understand) a bounded loop: **input → model → tool → observation → model → … → stop**.

This module adapts the agent-loop section of the async audit template and the kit’s “optional tool stub” idea. Prefer a **stub** (echo/clock/read-one-file) until stop conditions are proven.

## 1. Loop skeleton

Pseudocode:

```text
history = []
for turn in 1..MAX_TURNS:
  reply = chat(system, history, user_or_observation)
  log(reply)
  if is_final_answer(reply):
    return reply
  tool_call = parse_tool(reply)   # or explicit /tool … CLI
  if tool_call is None:
    return reply                  # model answered without a tool
  if tool_call.name not in ALLOWLIST:
    observation = "error: tool not allowed"
  else if tools_used_this_run >= MAX_TOOL_CALLS:
    observation = "error: tool budget exceeded; stop"
  else:
    observation = run_tool(tool_call)   # catch exceptions → string
  history += [assistant(reply), user("OBSERVATION:\n" + observation)]
return "stopped: max turns"
```

**Non-optional counters:** `MAX_TURNS`, `MAX_TOOL_CALLS`, wall-clock deadline.

## 2. Two common control styles

### A) Explicit CLI tools (simplest to debug)

User or agent types `/tool echo hello` or `/tool clock`. A thin router runs the stub and prints `tool> …` without another model call. Good for learning boundaries.

### B) Model-proposed tools

Model emits a structured call (JSON / XML / function-call format). Parser must be strict:

- Reject unknown names  
- Reject missing required args  
- Cap argument length  
- Never `eval` model text as code  

If parsing fails, feed a short error observation and continue **once** — then stop if it fails again.

## 3. State, memory, checkpoints

| Concern | Minimal practice |
|---------|------------------|
| History growth | Cap messages or summarize after N turns |
| Checkpoints | Write `run.jsonl` (turn, tool, latency, outcome) |
| Secrets | Redact before logging |
| Repro | Store model tag + host + git hash of your loop |

Silent death loops often come from unbounded history + no logs. Logging is part of the product, not “later.”

## 4. Stop conditions (write them in the system prompt too)

Examples you can paste:

- Stop when the user goal is answered in plain language with no further tool needed.  
- Stop after any tool error that repeats twice.  
- Stop if the same tool name + same args appear twice in a row.  
- Stop at `MAX_TURNS` even if the model wants another tool.

“Try forever until it works” is not a stop condition.

## 5. Observation hygiene

Tools should return **short, structured text**:

```text
OK: clock=2026-09-19T12:00:00-07:00
ERR: path outside allowlisted root
ERR: timeout after 10s
```

Avoid dumping megabytes into the next prompt (context blow-ups look like hangs or OOM).

## 6. Extension points (after it works)

Only after the stub loop is stable:

- One filesystem read rooted in a project dir  
- One HTTP GET to a fixed allowlisted URL (still local-dev only)  
- Eval harness: fixed prompts → pass/fail on non-empty + latency + keyword  

Do not add shell tools until you have an allowlist, a cwd jail, and a human watching the first runs.

## Done when

- [ ] You can point to `MAX_TURNS` and `MAX_TOOL_CALLS` in code or config  
- [ ] Allowlist is shorter than five tools  
- [ ] At least one successful stub tool observation is logged  
- [ ] Forced stop works (you tested max-turns)  

Next: Module 4 — failure modes.
