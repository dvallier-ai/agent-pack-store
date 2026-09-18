# Link / ASIN Health Kit

**SKU:** `link-asin-health-kit` · **Version:** 0.1.0 · **Price:** $29

CLI that watches **tagged links / ASINs from a CSV**, flags **dead / broken** URLs, and optionally notes simple **price diffs** from HTML (best-effort).

> **No Amazon Creators API required** for day-one. Status is plain HTTP. Price hints are naive scrapes — expect blocks and misses on heavily JS sites.

## What’s included

| Path | Purpose |
|------|---------|
| `scripts/check_links.py` | CSV → status table (+ optional report CSV) |
| `samples/links.csv` | Example rows (live + intentional dead/404) |
| `scripts/package.sh` | Builds versioned zip under `dist/` |
| `LICENSE` / `CHANGELOG.md` | MIT · history |

## CSV columns

| Column | Required | Notes |
|--------|----------|-------|
| `url` | yes | Full URL to probe |
| `label` | no | Human name |
| `asin` | no | Passed through for tagging / reports |
| `tag` | no | Your campaign or shelf tag |
| `notes` | no | Free text |
| `last_price` | no | Prior price for `--price-hint` diff |

## Quick start

```bash
cd link-asin-health-kit   # or unzip root
python3 scripts/check_links.py samples/links.csv
python3 scripts/check_links.py samples/links.csv --price-hint -o report.csv
echo $?   # 1 if any DEAD/BROKEN/ERROR
```

Statuses: `OK` · `REDIRECT` · `BROKEN` (404/410) · `DEAD` (DNS/connect) · `BLOCKED` (401/403) · `SERVER_ERR` · `ERROR`.

## Package

```bash
bash scripts/package.sh
# → dist/link-asin-health-kit-v0.1.0.zip
```

## Buy (BTC / ETH manual fulfill)

- Pay: `docs/pay-btc.html?sku=link-asin-health-kit`
- BTC: `bc1q2csjux4ey8at6muk7zhheyhvad9e4hudsumlzg`
- ETH (mainnet): `0xcBd03b1BE83BBBCCaA3aE00166f4a57c377324E8`
- Email proof: **dvallier@gmail.com**

## License

MIT — see `LICENSE`.
