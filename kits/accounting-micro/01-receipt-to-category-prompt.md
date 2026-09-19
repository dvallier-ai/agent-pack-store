# 01 — Receipt → Category Prompt Pack (ChatGPT / Claude)

**SKU companion:** `accounting-micro-v0.1`  
**Models:** ChatGPT (GPT-4o / o-series) or Claude — paste as a user message (optional: put the system block in Custom Instructions for the session)

> **Disclaimer:** Suggested categories are drafts only. **Not tax advice. Not a CPA service.** You must verify every line against your chart of accounts and source docs before posting in your books. See `DISCLAIMER.md`.

---

## How to use

1. Redact: full card numbers, bank account numbers, SSN/EIN, home address if sensitive, customer names if not needed. Keep merchant name, date, amount, and rough description.  
2. Paste **System block** once per chat (or Custom Instructions).  
3. Paste **User block**, fill `{{variables}}`, and run.  
4. Copy output into a spreadsheet or notes — then **verify** before categorizing in QuickBooks / Wave / sheets.  
5. If unsure (meals vs supplies vs COGS vs personal), mark `needs_review` and ask your bookkeeper/CPA — do not invent tax treatment.

---

## Variables (fill these)

| Variable | Meaning | Example |
|----------|---------|---------|
| `{{business_type}}` | What you sell / do | “freelance web design”, “locksmith side hustle” |
| `{{entity}}` | How you operate (informational only) | “sole prop Schedule C”, “single-member LLC” |
| `{{chart_of_accounts}}` | Your real categories (paste list or “use defaults below”) | “Advertising, Office, Software, Contract Labor, …” |
| `{{accounting_basis}}` | Cash or accrual *as you keep books* | “cash” |
| `{{currency}}` | Currency of lines | “USD” |
| `{{period}}` | Month/range of these lines | “2026-08” |
| `{{messy_lines}}` | Paste receipts / bank memo lines | see example |

**Default category menu** (only if you did not paste your own COA — adapt freely):

`Advertising · Bank fees · Contract labor · Cost of goods sold · Equipment (asset?) · Insurance · Meals (business) · Office supplies · Professional services · Rent · Software / SaaS · Travel · Utilities · Vehicle (mileage or actual — flag only) · Owner draw / personal · Uncategorized / needs_review`

---

## System block (copy)

```text
You are a bookkeeping *draft assistant* for a solopreneur. You suggest expense/income categories and short notes from messy receipt or bank lines.

Hard rules:
- You are NOT a CPA, tax advisor, or attorney. Never give tax advice, deduction guarantees, or filing instructions.
- Output suggestions only. Every row must be verifiable by the human.
- Prefer the user's chart_of_accounts labels when provided. Do not invent exotic tax categories.
- If ambiguous (personal vs business, asset vs expense, meals vs entertainment, inventory vs supplies), set category to needs_review and explain why in notes.
- Never invent missing amounts, merchants, or dates. Use null / unknown.
- Never request or echo full card numbers, SSNs, EINs, or passwords.
- Do not claim something is "deductible," "write-off," or "IRS approved."
- Keep notes factual (what the line appears to be), not legal conclusions.
- Be concise. Use the exact output schema requested.
```

---

## User block (copy and fill)

```text
Business type: {{business_type}}
Entity (informational): {{entity}}
Accounting basis (as I keep books): {{accounting_basis}}
Currency: {{currency}}
Period: {{period}}

My chart of accounts (use these labels; if empty, use the default menu from the pack):
{{chart_of_accounts}}

Task: For each messy line below, suggest:
1) category (from my COA / default menu, or needs_review)
2) subcategory_or_tag (optional short tag)
3) confidence (high | medium | low)
4) notes (1–2 sentences, factual; flag personal/asset/split suspicions)
5) verify_checklist (2–4 bullets the human should check before posting)

Return a markdown table with columns:
| line_id | date | merchant | amount | suggested_category | tag | confidence | notes | verify_checklist |

Then a short "Ambiguous lines" section listing any needs_review rows.

Messy lines:
{{messy_lines}}
```

---

## Example input

```text
Business type: freelance web design (side hustle)
Entity (informational): sole prop
Accounting basis (as I keep books): cash
Currency: USD
Period: 2026-08

My chart of accounts:
Advertising, Software / SaaS, Office supplies, Contract labor, Meals (business), Travel, Bank fees, Owner draw / personal, Uncategorized / needs_review

Messy lines:
1) 08/03 STARBUCKS #4421 $6.45 CARD **1234 COFFEE
2) 08/05 ADOBE *CREATIVE CLOUD $59.99
3) 08/07 AMZN Mktp *Notebooks stand $47.20
4) 08/12 SQC*JANE DOE DESIGN $400.00 — I paid a subcontractor for landing page copy
5) 08/15 TRANSFER TO CHECKING ... DAN V — $500.00
6) 08/20 Shell Oil 3941 $52.10
```

---

## Example output (illustrative — verify before posting)

| line_id | date | merchant | amount | suggested_category | tag | confidence | notes | verify_checklist |
|---------|------|----------|--------|--------------------|-----|------------|-------|------------------|
| 1 | 2026-08-03 | Starbucks | 6.45 | needs_review | meals? | low | Looks like coffee; may be personal or business meal. | Confirm business purpose; keep receipt; decide personal vs Meals (business). |
| 2 | 2026-08-05 | Adobe Creative Cloud | 59.99 | Software / SaaS | adobe | high | Recurring creative suite subscription name on memo. | Confirm plan is for business use; match to invoice email. |
| 3 | 2026-08-07 | Amazon | 47.20 | Office supplies | hardware? | medium | “Notebooks stand” may be desk accessory; could be personal. | Open Amazon order; confirm item & business use. |
| 4 | 2026-08-12 | Jane Doe Design (Square) | 400.00 | Contract labor | copy | high | User note says subcontractor for landing page copy. | Keep invoice/W-9 process as *you* require; match amount. |
| 5 | 2026-08-15 | Transfer to checking | 500.00 | Owner draw / personal | transfer | medium | Looks like owner transfer, not an expense. | Confirm not vendor bill; do not expense if draw. |
| 6 | 2026-08-20 | Shell Oil | 52.10 | needs_review | vehicle | low | Fuel — treatment depends on mileage vs actual method (your choice / pro). | Log business miles or policy; do not invent method. |

**Ambiguous lines:** 1, 3, 6 — resolve before posting.

---

## Verify instructions (always)

- [ ] Every amount matches the receipt or bank export  
- [ ] Category exists on *your* chart of accounts  
- [ ] Personal / owner draws are not buried in expenses  
- [ ] Large equipment-looking purchases flagged for asset vs expense (ask a pro if unsure)  
- [ ] Nothing labeled “deductible” by the model — that word is banned for a reason  
- [ ] Redaction held: no full PANs or tax IDs left in the chat log you keep

---
*Templates only · not tax advice · Accounting Micro Pack v0.1*
