# For locksmiths (and Kit / Otto)

## Owner walkthrough (locksmith-flavored)

You’re busy. Use the pack in this order:

1. **Tonight:** Customize `sms-templates/review-ask.txt` with your Google review link. After the next happy job, send it yourself from your phone.
2. **This week:** Post one tip from `google-business/` (deadbolt or spare-key). No discount required.
3. **When you have 20 minutes:** Open `booking/index.html`, put your business name in the title, host or link it from your Facebook/Google profile as “Request a visit.”
4. **When you’re ready for automation:** Import the n8n stubs. Keep Wait nodes short while testing. Wire SMS only after manual texts feel good.

### Suggested services list (edit in booking page)

- Lockout (home / auto)
- Lock change / rekey
- Key copy
- Deadbolt install
- After-hours emergency

### Review link

Google Business Profile → Ask for reviews → copy short link → paste into `{{google_review_url}}`.

---

## Tech notes (Kit / Otto)

- **SKU:** `local-biz-ops-kit` · **v0.1.0** · catalog **$199** (shelf $149–$299)
- **Buyer:** warm home-services (family locksmith first) — no cold spam campaigns
- **Zero capital path:** static booking + markdown templates; n8n webhook/manual only
- **Do not ship:** scraped lead lists, blast scripts, Dan personal brand / Gladiator content
- **n8n:** Wait nodes default to 1 minute for safe testing; sticky notes document real delays
- **Booking form:** client-side fallback if `action` is `#` or contains `YOUR_ID`
- **Package:** `scripts/package.sh` → `dist/local-biz-ops-kit-v0.1.0.zip`
- **Store integration:** listed in repo `catalog.json`; sell via warm outreach / existing checkout rails when wired
- **Compliance:** templates include STOP language; docs forbid purchased-list blasts
- **Extensions (later):** Twilio credentials in n8n only; calendar sync; real schedule math from `preferred_time`

### Smoke checklist before handoff

- [ ] `booking/index.html` opens and fallback summary works
- [ ] Four SMS templates have `{{tokens}}`
- [ ] ≥8 GBP markdown drafts present
- [ ] Two n8n JSON files parse as JSON
- [ ] `bash scripts/package.sh` produces zip under `dist/`
- [ ] README honest about no auto-SMS on day one
