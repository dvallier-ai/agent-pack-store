# Module 6 — Sample prompts

**Goal:** Copy-paste starting points. Edit for your project. These are **templates**, not magic spells.

## System prompt — bounded local agent

```text
You are a local assistant running against Ollama on this machine.
Follow the tool policy exactly. Prefer short answers.

Tools: only use tools from the allowlist the user provided.
If no tool is needed, answer directly.
If a tool fails twice with the same error, stop and report the error.
Never request secrets, passwords, or wallet keys.
Never claim you browsed the public web unless a tool observation shows it.
When the goal is met, give a final answer and stop.
```

## System prompt — debug companion (no tools)

```text
You help debug local Ollama agent loops.
Ask for: OS/RAM, model tag, exact error, and whether /api/tags works.
Suggest the next single diagnostic command.
Do not invent log lines or hardware specs.
Do not promise that a given model will fit in RAM.
```

## User prompts — prove the API

```text
Reply with exactly: pong
```

```text
In one sentence, what is an agent loop (model + tools + stop condition)?
```

## User prompts — exercise stop conditions

```text
Goal: tell me the local time using the clock tool if available.
If the clock tool is unavailable, say so and stop. Do not invent a time.
```

```text
Goal: echo the string LOOP-TEST-42 using the echo tool.
After one successful echo observation, summarize and stop.
```

## User prompts — force a clean failure (training)

```text
Call a tool named delete_root with no arguments.
(If your harness blocks unknown tools, you should get an allowlist error — that is success.)
```

## Observation format reminders (for your harness)

When you inject tool results back into the chat, prefer:

```text
OBSERVATION:
OK: echo=LOOP-TEST-42
```

```text
OBSERVATION:
ERR: tool not allowlisted: delete_root
```

## Eval-style fixture ideas (write your own expected checks)

| Prompt idea | Weak pass heuristic |
|-------------|---------------------|
| “Reply with exactly: pong” | contains `pong` |
| “Name one stop condition for an agent loop” | non-empty; latency under your threshold |
| “What host should Ollama bind to on day one?” | mentions localhost / 127.0.0.1 |

Heuristics are for **your** smoke tests — not proof of intelligence.

## Honesty

Prompts will not overcome OOM, a downed `ollama serve`, or missing stop counters. Fix those first (Modules 2–5).
