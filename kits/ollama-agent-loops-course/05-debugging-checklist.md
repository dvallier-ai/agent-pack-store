# Module 5 — Debugging checklist

**Goal:** A printable, audit-template-shaped pass you can fill when a loop breaks. Reuse this for self-serve debugging or as intake if you later buy an async audit.

## Intake (fill once per incident)

- Date (PT):  
- Goal / expected workload:  
- OS / hardware:  
- Repo or script path:  
- Constraints (privacy, offline, latency):  
- Reproduction command:  

## A. Environment

- [ ] OS and version noted  
- [ ] CPU / GPU / RAM / disk noted  
- [ ] Python / runtime versions noted (if applicable)  
- [ ] Relevant env vars recorded (**redact secrets**)  
- [ ] Observed errors / logs attached (redacted)

## B. Ollama / runner

- [ ] `ollama --version` (or runner equivalent)  
- [ ] `ollama list` / models + tags  
- [ ] Context / quant notes  
- [ ] `ollama serve` status  
- [ ] `curl http://127.0.0.1:11434/api/tags` succeeds  
- [ ] Pull / storage / permissions issues ruled out  
- [ ] RAM/VRAM behavior noted (OOM? thrash? fine?)

## C. Agent loop

- [ ] Entry point + run command known  
- [ ] System prompt / tool policy readable  
- [ ] Input → model → tool → observation path traced once on paper  
- [ ] State / memory / checkpoint location known  
- [ ] Stop conditions + retry limits exist **in code or config**  
- [ ] File / shell / network / secret boundaries stated  
- [ ] Logging is on for this run

## D. Evaluation snapshot

- [ ] Success criteria written in one sentence  
- [ ] One representative failing case identified  
- [ ] Baseline: last known good commit / config  
- [ ] Latency / quality notes for this run  
- [ ] Likely cause hypothesis (one sentence)  
- [ ] Evidence: log lines, traces, sample outputs

## E. Fix list (prioritize)

| Priority | Fix | Why it matters | Suggested change | Effort | Verification |
|----------|-----|----------------|------------------|--------|--------------|
| P0 |  |  |  |  |  |
| P1 |  |  |  |  |  |
| P2 |  |  |  |  |  |

### Recommended next run

1.  
2.  
3.  

## F. Quick triage order (when short on time)

1. API reachable? (`/api/tags`)  
2. Model tag exists? (`ollama list`)  
3. Non-stream chat works without tools?  
4. Counters present? (`MAX_TURNS`, tool budget)  
5. Observations actually appended to history?  
6. Observation size / OOM?  

Stop when P0 is verified fixed; do not boil the ocean on P2 prompts.

*Aligned with Passive Engine `audit-template.md` sections — education/self-serve use.*
