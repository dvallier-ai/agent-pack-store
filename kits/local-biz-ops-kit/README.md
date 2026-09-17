# Local Biz Ops Kit

**SKU:** `local-biz-ops-kit` · **Version:** 0.1.0 · **Catalog price:** $199 (shelf $149–$299)

An agent-built ops pack for small **home-services** businesses (locksmith, plumber, HVAC-class). You run it yourself: review-ask texts, appointment reminders, a simple booking page, and Google Business post drafts. Includes **n8n** workflow stubs and optional local scripts.

**First buyer intent:** warm / known contacts (e.g. a family locksmith) — not cold email blasts.

## Who it’s for

- Solo or small-crew locksmiths, plumbers, HVAC, handymen who already have customers
- Owners who can open a folder, copy text into their phone/SMS app, and (optionally) import an n8n workflow
- Anyone who wants a booking request form on a website or Netlify/GitHub Pages — without buying another SaaS on day one

## What’s in the box

| Path | Purpose |
|------|---------|
| `booking/` | Static HTML/CSS booking request page (name, phone, service, preferred time, notes) |
| `sms-templates/` | Copy with `{{tokens}}`: review ask, 24h/2h reminders, no-show follow-up |
| `google-business/` | 10 editable GBP post drafts (seasonal, promo, tip, emergency hours) |
| `n8n/` | 2 importable workflow stubs (webhook/manual triggers — no paid APIs required to open) |
| `scripts/` | Optional helpers (e.g. generate a week of GBP posts); `package.sh` → zip |
| `docs/install.md` | Plain-English install for non-dev owners |
| `docs/for-locksmith.md` | Locksmith-flavored walkthrough + Kit/Otto tech notes |

## Honest scope (v0.1.0)

**This pack does:**

- Give you copy-paste templates and a hostable booking page
- Give you n8n stubs you can import and wire to *your* SMS/email later
- Stay near-zero capital: no Twilio keys required to open or trial the pack

**This pack does not:**

- Send SMS for you out of the box (optional Twilio/etc. later — you add keys)
- Scrape leads, blast strangers, or include spam scripts
- Replace your calendar, CRM, or Google Business Profile login
- Guarantee more reviews or jobs — templates only

## Requirements

Pick one path (or both):

1. **Local / static only** — a browser + a text editor. Open `booking/index.html`, copy SMS templates into your phone, paste GBP drafts into Google Business.
2. **n8n** — [n8n Cloud](https://n8n.io) free trial or self-hosted. Import JSON from `n8n/`. Workflows use **Webhook** and **Manual** triggers so day-one testing needs no paid SMS API.

Optional later: Twilio (or similar) for automated SMS; Formspree / your own webhook for the booking form.

## Quickstart (5 minutes)

1. Unzip the pack (or open `kits/local-biz-ops-kit/` in this repo).
2. **Booking page:** open `booking/index.html` in a browser (double-click or `python3 -m http.server 8080` from `booking/`). Edit the yellow “wire your endpoint” note when ready.
3. **SMS:** open `sms-templates/`, replace `{{business_name}}`, `{{google_review_url}}`, etc., paste into Messages / your SMS tool for one real customer you already know.
4. **GBP:** open any file in `google-business/`, customize, paste into a Google Business post.
5. **n8n (optional):** see `n8n/README.md` — Import from File → activate → hit the webhook or Manual trigger.

```bash
# Optional: generate a week of post drafts into a single markdown file
python3 scripts/generate-gbp-week.py

# Optional: build a shippable zip
bash scripts/package.sh
# → dist/local-biz-ops-kit-v0.1.0.zip
```

## Legal / anti-spam

Use templates only with people who opted in or who are existing customers. Do **not** use this kit to scrape locksmith directories or blast cold lists. Compliance (TCPA, CAN-SPAM, local rules) is your responsibility.

## License

MIT — see `LICENSE`.
