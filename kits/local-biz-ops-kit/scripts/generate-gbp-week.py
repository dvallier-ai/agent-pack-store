#!/usr/bin/env python3
"""Generate a simple 7-day Google Business post plan from templates."""
from __future__ import annotations

import argparse
from datetime import date, timedelta
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GBP = ROOT / "google-business"
DEFAULT_OUT = ROOT / "google-business" / "week-plan.md"

# Rotate through tip/promo/seasonal-ish set
DEFAULT_ORDER = [
    "05-tip-spare-key.md",
    "01-emergency-hours.md",
    "04-promo-rekey.md",
    "06-tip-deadbolt.md",
    "07-community-thanks.md",
    "02-seasonal-winter.md",
    "10-hiring-or-hours.md",
]


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--start", default=date.today().isoformat(), help="YYYY-MM-DD start (default: today)")
    ap.add_argument("-o", "--output", type=Path, default=DEFAULT_OUT)
    ap.add_argument("--business", default="YOUR BUSINESS NAME")
    ap.add_argument("--city", default="YOUR CITY")
    ap.add_argument("--phone", default="(555) 555-0100")
    args = ap.parse_args()

    start = date.fromisoformat(args.start)
    lines = [
        f"# GBP week plan — {args.business}",
        f"Generated for week of {start.isoformat()} · edit before posting",
        "",
    ]

    for i, name in enumerate(DEFAULT_ORDER):
        day = start + timedelta(days=i)
        path = GBP / name
        body = path.read_text(encoding="utf-8") if path.exists() else f"(missing {name})"
        body = (
            body.replace("{{business_name}}", args.business)
            .replace("{{city_or_area}}", args.city)
            .replace("{{phone}}", args.phone)
        )
        lines.append(f"## {day.strftime('%A %Y-%m-%d')} — {name}")
        lines.append("")
        lines.append(body.strip())
        lines.append("")
        lines.append("---")
        lines.append("")

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {args.output}")


if __name__ == "__main__":
    main()
