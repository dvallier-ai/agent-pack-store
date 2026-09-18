# Before → After: Zapier Typeform → CRM lead router (dedupe + SLA)
**SKU:** Async automation repair sample  
**Status:** Portfolio stub — fictional SMB; public-pattern writeup  
**Suggested fixed price band (comps):** $100–$250 · **Not a live engagement**

---

## Client context (anonymized / fictional)
Local HVAC company. Typeform “Get a quote” → Zapier → HubSpot contact + Slack #leads.  
**Pain:** Same homeowner submits 2–3 times; techs double-book; SLA clock never starts.

## Before (broken)
```
Typeform submit ──► Zapier ──► Create HubSpot Contact (always)
                      │
                      └─► Slack #leads (raw answers, no owner)
```
- No email/phone normalize → “Dan V.” / “dan v” / “dan@…” = 3 contacts
- No round-robin; first tech who sees Slack wins (or nobody does)
- No “responded within 15 min” property → can’t measure speed-to-lead

## After (fixed pattern)
```
Typeform ──► Formatter (email lower, phone E.164)
                │
                ├─ Find HubSpot contact by email OR phone
                │     ├─ found ──► Update + append note + set lifecycle=MQL
                │     └─ new ──► Create + assign owner (round-robin table)
                │
                ├─ Set `sla_due_at` = now + 15m
                │
                └─ Slack → @owner only + buttons: Claim / Snooze / Spam
```
**Concrete Zapier / Make moves**
1. **Formatter** steps: email lowercase; phone digits-only → E.164 US.
2. **HubSpot Find/Create** with email primary, phone secondary match.
3. **Storage / Google Sheet** round-robin cursor (tech A → B → C).
4. **Delay + Filter** follow-up Zap: if `sla_due_at` passed & stage still NEW → escalate Slack + SMS.
5. **Paths**: spam keywords → trash + no CRM create.

## Acceptance criteria (done-when)
- [ ] Same email within 24h updates one contact (not a second)
- [ ] Every new lead has an owner in ≤1 minute of submit
- [ ] Missed 15-min SLA posts to #leads-escalation once
- [ ] One-pager “how to add a tech to the rotation” left with office manager

## Deliverables in a paid gig
- Zap export / Make blueprint link
- Round-robin sheet template
- SLA property list for HubSpot (or Pipedrive equivalent)

## Time estimate
2–3 hours including CRM property cleanup · fixed **$149–$199** typical.

---
*Sample portfolio piece · Passive Engine · 2026-09-18 PT · no client claimed*
