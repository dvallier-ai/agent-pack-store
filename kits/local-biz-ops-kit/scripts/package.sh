#!/usr/bin/env bash
# Package Local Biz Ops Kit into dist/ as a versioned zip (Python zipfile — no system zip required).
set -euo pipefail

KIT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="0.1.0"
SKU="local-biz-ops-kit"
OUT_DIR="$KIT_DIR/dist"
ZIP_NAME="${SKU}-v${VERSION}.zip"
ZIP_PATH="$OUT_DIR/$ZIP_NAME"

mkdir -p "$OUT_DIR"
rm -f "$ZIP_PATH"

python3 - "$KIT_DIR" "$ZIP_PATH" "$SKU" <<'PY'
import sys
import zipfile
from pathlib import Path

kit_dir = Path(sys.argv[1])
zip_path = Path(sys.argv[2])
sku = sys.argv[3]

exclude_names = {"__pycache__", ".venv", ".DS_Store", ".pytest_cache", "dist"}
exclude_suffixes = {".pyc"}

with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
    for path in sorted(kit_dir.rglob("*")):
        if not path.is_file():
            continue
        rel = path.relative_to(kit_dir)
        if any(p in exclude_names for p in rel.parts):
            continue
        if path.suffix in exclude_suffixes:
            continue
        # Don't nest the output zip inside itself if re-run oddly
        if path.resolve() == zip_path.resolve():
            continue
        arcname = f"{sku}/{rel.as_posix()}"
        zf.write(path, arcname)

print(f"Created: {zip_path}")
with zipfile.ZipFile(zip_path) as zf:
    print(f"files: {len(zf.namelist())}")
print(f"size_bytes: {zip_path.stat().st_size}")
PY

ls -lh "$ZIP_PATH"
