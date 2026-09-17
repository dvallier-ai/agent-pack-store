# Install guide (plain English)

For shop owners who are not developers. Tech notes for agents (Kit / Otto) are at the bottom of `for-locksmith.md`.

## What you need

- A computer or phone to open files
- Your Google Business Profile login (for posts)
- Your usual way to text customers (iPhone Messages, Android, business SMS — whatever you already use)
- Optional: a free [n8n](https://n8n.io) account if you want automation stubs

**You do not need** Twilio, a developer, or a new paid form product to try this pack.

## Step 1 — Unzip

Unzip `local-biz-ops-kit-v0.1.0.zip`. You should see folders: `booking`, `sms-templates`, `google-business`, `n8n`, `scripts`, `docs`.

## Step 2 — Booking page (5 minutes)

1. Open the `booking` folder.
2. Double-click `index.html` (or drag it into Chrome/Safari/Edge).
3. Fill the form once as a test. You’ll see a **copy summary** box — that’s normal until you wire an endpoint.
4. To put it on the web later: upload the `booking` folder to Netlify Drop, Cloudflare Pages, or GitHub Pages. Or ask whoever built your site to embed/link it.
5. When ready for real submissions: edit `index.html` and set the form `action` to Formspree or your n8n webhook (see yellow note on the page).

## Step 3 — Text templates

1. Open `sms-templates`.
2. Open a `.txt` file in Notepad / TextEdit.
3. Replace every `{{something}}` with your real info (business name, review link, etc.).
4. Copy the finished text into a message to **one customer you already know** and send manually.
5. If it feels right, save your filled-in versions for next time.

**Do not** paste these into a purchased lead list or a “blast 500 numbers” tool.

## Step 4 — Google posts

1. Open `google-business`.
2. Pick a draft (start with emergency hours or a tip).
3. Edit city, phone, and offer details.
4. In Google Business Profile → Posts → Create post → paste → publish (add a photo if you have one).

## Step 5 — n8n (optional)

1. Sign up for n8n Cloud or run n8n on a computer you control.
2. Import → choose a file from the `n8n` folder.
3. Hit **Manual Trigger** to test. Nothing sends SMS until you add that yourself later.

## Optional later: automatic texts

When you’re ready: add Twilio (or similar) inside n8n, store API keys in n8n credentials only, and paste the SMS templates into the message body. Keep STOP/opt-out language. Follow US texting rules (TCPA) — if unsure, ask a lawyer or stick to manual texts.

## Packaged zip

From the kit folder:

```bash
bash scripts/package.sh
```

Creates `dist/local-biz-ops-kit-v0.1.0.zip`.
