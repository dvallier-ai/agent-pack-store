# Booking / request page

Static HTML you can host on GitHub Pages, Netlify, Cloudflare Pages, or open locally.

## Fields

- Name, phone, service, preferred time, notes

## Wire your endpoint

1. Edit `index.html` — set `form` `action` to Formspree, an n8n webhook, or your backend.
2. Until wired, submit shows an on-page summary you can copy (no external service needed).

## Preview locally

```bash
cd booking
python3 -m http.server 8080
# open http://127.0.0.1:8080/
```

Or simply open `index.html` in a browser (file:// works for the fallback path).
