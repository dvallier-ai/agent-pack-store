# Before → After: n8n webhook → Slack (retry + dead-letter)
**SKU:** Async “fix my Zapier/Make/n8n” micro-gig sample  
**Status:** Portfolio stub — shippable shape, fictional client details  
**Suggested fixed price band (comps):** $75–$150 · **Not a live engagement**

---

## Client context (anonymized / fictional)
Solo e-commerce operator. Public Stripe → n8n webhook → Slack “new paid order” alert.  
**Pain:** ~8% of webhooks silent-fail overnight; no retry; Slack misses weekend sales.

## Before (broken)
```
Stripe webhook ──► n8n Webhook node ──► Slack (message)
                     │
                     └─ on 5xx / timeout: drop (no queue, no alert)
```
- Single Webhook trigger, no signature verify beyond default
- No Error Trigger / Error Workflow
- No idempotency on `payment_intent` / `checkout.session` id
- Slack rate-limit → entire run fails, no DLQ

## After (fixed pattern)
```
Stripe webhook ──► Verify signature ──► Dedupe (Data Store / Redis)
                         │
                         ├─ success ──► Format order card ──► Slack
                         │
                         └─ fail ──► Error Workflow ──► Retry (3×, exp backoff)
                                        │
                                        └─ still fail ──► DLQ sheet + SMS/email
```
**Concrete n8n moves**
1. **Error Workflow** on the production workflow (catch + classify).
2. **Wait + Loop** retry (3 attempts, 30s / 2m / 10m).
3. **Data Store** key = Stripe event `id` → skip duplicates.
4. **IF** Slack HTTP ≥429 → wait-Retry-After, else DLQ Google Sheet row.
5. Daily **Schedule** digest: “failed overnight = N rows in DLQ.”

## Acceptance criteria (done-when)
- [ ] Duplicate Stripe events create **0** extra Slack posts
- [ ] Forced 500 on Slack path lands in DLQ within 15 min
- [ ] Operator can re-run DLQ row with one button / manual trigger
- [ ] 1-page runbook left in client Notion

## Deliverables in a paid gig
- Workflow JSON export + screenshot of Error Workflow
- 1-page runbook (this doc condensed)
- 15-min Loom walkthrough (optional)

## Time estimate
90–150 minutes for a competent n8n fixer · fixed **$99** entry common.

---
*Sample portfolio piece · Passive Engine · 2026-09-18 PT · no client claimed*
