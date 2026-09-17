# n8n workflows

Two **importable stubs**. They use Webhook + Manual triggers so you can open and test without Twilio or other paid APIs on day one.

## Import

1. Open n8n (Cloud or self-hosted).
2. **Workflows → Import from File** (or ⋮ → Import).
3. Choose `booking-to-reminders.json` or `job-complete-review-ask.json`.
4. Open the workflow → click **Manual** or copy the Webhook URL after activate.
5. Replace placeholder nodes (Set / Wait / sticky notes) with your SMS or email when ready.

## Workflows

| File | Trigger | Intent |
|------|---------|--------|
| `booking-to-reminders.json` | Webhook POST (booking payload) **or** Manual | Capture booking → schedule reminder placeholders (24h / 2h) |
| `job-complete-review-ask.json` | Webhook POST **or** Manual | Job complete → Wait (delay) → review-ask message placeholder |

## Day-one test (no SMS)

1. Import `booking-to-reminders.json`.
2. Click **Test workflow** / execute **Manual Trigger**.
3. Confirm the Set node shows sample customer fields.
4. When you have SMS later: add Twilio (or HTTP Request to your provider) after the Wait nodes — keep keys in n8n credentials, never in this repo.

## Webhook payload example (booking)

```json
{
  "name": "Jordan Lee",
  "phone": "+15555550123",
  "service": "Lock change / rekey",
  "preferred_time": "Thu after 4pm",
  "notes": "Side gate unlocked"
}
```

Point `booking/index.html` form `action` at the Production webhook URL when ready.
