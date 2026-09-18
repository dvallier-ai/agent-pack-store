#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VER="0.1.0"
NAME="automation-gig-templates-pack"
OUT="$ROOT/dist/${NAME}-v${VER}.zip"
mkdir -p "$ROOT/dist"
rm -f "$OUT"
if command -v zip >/dev/null 2>&1; then
  (cd "$ROOT" && zip -r "$OUT" README.md DISCLAIMER.md CHANGELOG.md LICENSE sample samples templates 2>/dev/null || true)
fi
if [[ ! -f "$OUT" ]]; then
  python3 - << PY
import zipfile
from pathlib import Path
root = Path("$ROOT")
out = Path("$OUT")
names = ["README.md", "DISCLAIMER.md", "CHANGELOG.md", "LICENSE", "sample", "samples", "templates"]
with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as zf:
    for name in names:
        p = root / name
        if p.is_file():
            zf.write(p, name)
        elif p.is_dir():
            for f in p.rglob("*"):
                if f.is_file():
                    zf.write(f, f.relative_to(root).as_posix())
print("Wrote", out)
PY
fi
ls -la "$OUT"
