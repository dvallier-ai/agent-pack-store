# Import and run — n8n Local Agent Workflow Pack

## Import

1. Open n8n → **Workflows** → **⋯** → **Import from File**.
2. Import `workflows/01-webhook-ollama-chat.json`, then `02`, then `03`.
3. For each workflow: open **Settings** → attach an **Error Workflow** if you have one (recommended for `02`).

## Environment (optional)

| Variable | Used by | Default idea |
|----------|---------|--------------|
| `DOWNSTREAM_URL` | `02` Call Downstream | Your real HTTP sink |
| `DLQ_WEBHOOK` | `02` Dead Letter | Sheet/webhook/email bridge |
| `DIGEST_WEBHOOK` | `03` Post Digest | Slack incoming webhook proxy |

Without env vars, stubs call `http://127.0.0.1:9999/…` so you can see failures clearly.

## Smoke checklist

- [ ] Ollama responds: `curl http://127.0.0.1:11434/api/tags`
- [ ] Workflow `01` active; webhook path `local-agent-chat` returns JSON with `response`
- [ ] Workflow `02`: force downstream 500 → Wait → attempt bump (inspect executions)
- [ ] Workflow `03`: **Execute Workflow** manually once before trusting the schedule
- [ ] Production: replace echo URLs; add signature verify on public webhooks

## Retry / DLQ notes

Pattern mirrors common “silent webhook fail” repairs:

1. Normalize `event_id` for later idempotency (add Data Store / Redis in prod).
2. Gate on `attempt ≤ 3`.
3. On downstream error → Wait (30s stub) → bump → re-enter gate.
4. Else → Dead Letter POST.

Tune backoff (30s / 2m / 10m) and swap Wait for n8n Error Workflow + Queue when you harden.

## Security

- Do not expose webhook paths without auth or signature checks on the public internet.
- Keep Ollama bound to localhost unless you intentionally reverse-proxy it.
