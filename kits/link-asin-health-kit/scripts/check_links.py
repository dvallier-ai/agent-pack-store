#!/usr/bin/env python3
"""
link-asin-health-kit — watch tagged links / ASINs from CSV.

Day-one: HTTP status + DNS/timeout flags. Optional naive price scrape note
when --price-hint finds a $X.XX near known markers (best-effort, no API).

No Amazon Creators API required.
"""
from __future__ import annotations

import argparse
import csv
import re
import sys
import urllib.error
import urllib.request
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

USER_AGENT = "link-asin-health-kit/0.1 (+local; research/ops)"
PRICE_RE = re.compile(r"\$\s?(\d{1,5}(?:\.\d{2})?)")


@dataclass
class Result:
    label: str
    url: str
    asin: str
    tag: str
    status: str
    http_code: Optional[int]
    note: str
    price_seen: str
    price_diff: str


def fetch(url: str, timeout: float) -> tuple[Optional[int], str, str]:
    """Return (http_code, body_snippet_or_empty, error_note)."""
    req = urllib.request.Request(
        url,
        headers={"User-Agent": USER_AGENT, "Accept": "text/html,*/*"},
        method="GET",
    )
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            code = getattr(resp, "status", None) or resp.getcode()
            raw = resp.read(80_000)
            try:
                text = raw.decode("utf-8", errors="replace")
            except Exception:
                text = ""
            return int(code), text, ""
    except urllib.error.HTTPError as e:
        body = ""
        try:
            body = e.read(40_000).decode("utf-8", errors="replace")
        except Exception:
            pass
        return int(e.code), body, f"HTTPError:{e.code}"
    except urllib.error.URLError as e:
        return None, "", f"URLError:{e.reason}"
    except Exception as e:  # noqa: BLE001 — CLI wants a flag, not a crash
        return None, "", f"{type(e).__name__}:{e}"


def classify(code: Optional[int], err: str) -> str:
    if err.startswith("URLError"):
        return "DEAD"
    if code is None:
        return "ERROR"
    if code == 404 or code == 410:
        return "BROKEN"
    if 200 <= code < 300:
        return "OK"
    if 300 <= code < 400:
        return "REDIRECT"
    if code in (401, 403):
        return "BLOCKED"
    if code >= 500:
        return "SERVER_ERR"
    return f"HTTP_{code}"


def price_hint(html: str) -> str:
    if not html:
        return ""
    # Prefer prices near common commerce markers; fall back to first $ amount.
    window = html
    for marker in ("price", "a-price", "product-price", "amount"):
        idx = html.lower().find(marker)
        if idx >= 0:
            window = html[max(0, idx - 40) : idx + 200]
            m = PRICE_RE.search(window)
            if m:
                return m.group(1)
    m = PRICE_RE.search(html[:15_000])
    return m.group(1) if m else ""


def diff_note(last: str, seen: str) -> str:
    if not last or not seen:
        return ""
    try:
        a, b = float(last), float(seen)
    except ValueError:
        return ""
    delta = b - a
    if abs(delta) < 0.005:
        return "unchanged"
    sign = "+" if delta > 0 else ""
    return f"{sign}{delta:.2f}"


def load_rows(path: Path) -> list[dict]:
    with path.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        if not reader.fieldnames or "url" not in {h.strip().lower() for h in reader.fieldnames}:
            raise SystemExit("CSV must include a 'url' column")
        # Normalize keys to lowercase
        rows = []
        for row in reader:
            norm = {(k or "").strip().lower(): (v or "").strip() for k, v in row.items()}
            if not norm.get("url"):
                continue
            rows.append(norm)
        return rows


def run(csv_path: Path, timeout: float, do_price: bool, out_path: Optional[Path]) -> int:
    rows = load_rows(csv_path)
    results: list[Result] = []
    for row in rows:
        url = row["url"]
        code, body, err = fetch(url, timeout)
        status = classify(code, err)
        seen = price_hint(body) if do_price and body else ""
        last = row.get("last_price", "")
        note = err or row.get("notes", "")
        if status == "OK" and not note:
            note = "reachable"
        results.append(
            Result(
                label=row.get("label", ""),
                url=url,
                asin=row.get("asin", ""),
                tag=row.get("tag", ""),
                status=status,
                http_code=code,
                note=note,
                price_seen=seen,
                price_diff=diff_note(last, seen) if do_price else "",
            )
        )

    # stdout table
    headers = ["status", "code", "asin", "tag", "label", "price_seen", "price_diff", "note", "url"]
    print("\t".join(headers))
    bad = 0
    for r in results:
        if r.status not in ("OK", "REDIRECT", "BLOCKED"):
            bad += 1
        print(
            "\t".join(
                [
                    r.status,
                    "" if r.http_code is None else str(r.http_code),
                    r.asin,
                    r.tag,
                    r.label,
                    r.price_seen,
                    r.price_diff,
                    r.note.replace("\t", " ")[:80],
                    r.url,
                ]
            )
        )

    if out_path:
        with out_path.open("w", newline="", encoding="utf-8") as f:
            w = csv.DictWriter(
                f,
                fieldnames=[
                    "label",
                    "url",
                    "asin",
                    "tag",
                    "status",
                    "http_code",
                    "price_seen",
                    "price_diff",
                    "note",
                ],
            )
            w.writeheader()
            for r in results:
                w.writerow(
                    {
                        "label": r.label,
                        "url": r.url,
                        "asin": r.asin,
                        "tag": r.tag,
                        "status": r.status,
                        "http_code": r.http_code if r.http_code is not None else "",
                        "price_seen": r.price_seen,
                        "price_diff": r.price_diff,
                        "note": r.note,
                    }
                )
        print(f"\nWrote report: {out_path}", file=sys.stderr)

    print(f"\nSummary: {len(results)} checked, {bad} dead/broken/error", file=sys.stderr)
    return 1 if bad else 0


def main() -> None:
    p = argparse.ArgumentParser(description="Flag dead/broken tagged links & ASINs from CSV (no Creators API).")
    p.add_argument("csv", nargs="?", default="samples/links.csv", help="Input CSV (default: samples/links.csv)")
    p.add_argument("--timeout", type=float, default=12.0, help="Per-request timeout seconds")
    p.add_argument("--price-hint", action="store_true", help="Best-effort $ price scrape from HTML")
    p.add_argument("-o", "--out", help="Write CSV report path")
    args = p.parse_args()
    csv_path = Path(args.csv)
    if not csv_path.is_file():
        raise SystemExit(f"CSV not found: {csv_path}")
    out = Path(args.out) if args.out else None
    raise SystemExit(run(csv_path, args.timeout, args.price_hint, out))


if __name__ == "__main__":
    main()
