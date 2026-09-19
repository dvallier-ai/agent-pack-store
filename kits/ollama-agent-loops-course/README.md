# Ollama Agent Loops Mini-Course Pack

**SKU:** `ollama-agent-loops-course-v0.1`  
**Version:** 0.1  
**Price:** **$39** one-time zip  
**Rail:** BTC / ETH manual fulfill → email txid to `dvallier@gmail.com`  
**Pay page:** https://dvallier-ai.github.io/agent-pack-store/pay-btc.html?sku=ollama-agent-loops-course

A short, self-serve teach pack for hobbyist local-LLM users stuck on **agent loops** — OOM, API bind failures, silent death loops, and tool-use that never stops. Same audience as the async Local LLM audit offer; this is productized knowledge you work through yourself, not a live service.

Adapted from Passive Engine audit-template sections and the Ollama Local Agent Kit docs (architecture, troubleshooting, loop patterns). **No fake case studies. No earnings claims.**

## What you get

| File | Topic |
|------|--------|
| `01-setup-boundaries.md` | Hardware reality, privacy, bind address, what not to expose |
| `02-runner-api.md` | Ollama serve, `/api/tags` / `/api/chat`, host/model env |
| `03-tool-use-loops.md` | Input → model → tool → observation; stop/retry limits |
| `04-failure-modes.md` | OOM, connection refused, silent loops, missing models |
| `05-debugging-checklist.md` | Printable P0→P2 checklist (audit-template shaped) |
| `06-sample-prompts.md` | Copy-paste system prompts + loop-test prompts |
| `07-license-disclaimer.md` | License + honesty limits |

## Who it’s for

- Hobbyists / indie builders already running (or trying to run) **Ollama** on a laptop or mini PC
- People whose agent “runs forever,” OOMs mid-tool, or can’t reach `127.0.0.1:11434`
- Anyone who wants a **written** path from stuck → bounded loop before buying an async audit or a code kit

## Not for

- “Build me a ChatGPT clone” or enterprise SOC2 / compliance audits
- Guaranteed speedups, guaranteed 70B-on-8GB, or income promises
- Live Zoom coaching, remote desktop, or same-day on-call support
- Cloud-only API agent frameworks (this pack is **local Ollama–centric**)

## How to use

1. Skim `01`–`02` and confirm your runner answers `curl` on localhost.  
2. Walk `03`–`04` against your actual loop (or a minimal stub).  
3. Run `05` once; keep the filled checklist.  
4. Steal prompts from `06`; stay inside the boundaries in `01` and `07`.

## Related (optional, not required)

- Free magnet: Local-LLM Setup Checklist (`checklist-pack-v0.1`)  
- Async audit service: `$79` written fix list (separate offer)  
- Code kit: `ollama-local-agent-kit` `$79` installable agent + eval  

This course stands alone. Kits and audits are optional next steps if you still want them after working the modules.

## Honesty

Educational materials only. Not affiliated with Ollama, Meta, or any model vendor. Your results depend on hardware, model choice, and how you implement the loop. See `07-license-disclaimer.md`.

*Passive Engine · 2026-09-19 PT*
