#!/usr/bin/env bash
# Package ollama-local-agent-kit into dist/ as a versioned zip.
# Uses Python zipfile (no system `zip` required).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
KIT_DIR="$ROOT/kits/ollama-local-agent-kit"
VERSION="0.1.0"
SKU="ollama-local-agent-kit"
OUT_DIR="$ROOT/dist"
ZIP_NAME="${SKU}-v${VERSION}.zip"
ZIP_PATH="$OUT_DIR/$ZIP_NAME"

if [[ ! -d "$KIT_DIR" ]]; then
  echo "error: kit directory not found: $KIT_DIR" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"
rm -f "$ZIP_PATH"

python3 - "$KIT_DIR" "$ZIP_PATH" "$SKU" <<'PY'
import sys
import zipfile
from pathlib import Path

kit_dir = Path(sys.argv[1])
zip_path = Path(sys.argv[2])
sku = sys.argv[3]

exclude_names = {"__pycache__", ".venv", ".DS_Store", ".pytest_cache"}
exclude_suffixes = {".pyc"}
exclude_files = {".env", "report.json", "report.md"}

with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
    for path in sorted(kit_dir.rglob("*")):
        if not path.is_file():
            continue
        parts = set(path.parts)
        if parts & exclude_names:
            continue
        if path.suffix in exclude_suffixes:
            continue
        if path.name in exclude_files and path.parent.name == "eval":
            continue
        arcname = f"{sku}/{path.relative_to(kit_dir).as_posix()}"
        zf.write(path, arcname)

print(f"Created: {zip_path}")
print(f"Entries: {len(zf.namelist()) if False else 'ok'}")
PY

# Re-open briefly for entry count + size
python3 - "$ZIP_PATH" <<'PY'
import sys, zipfile
from pathlib import Path
p = Path(sys.argv[1])
with zipfile.ZipFile(p) as zf:
    print(f"files: {len(zf.namelist())}")
print(f"size_bytes: {p.stat().st_size}")
PY

ls -lh "$ZIP_PATH"
