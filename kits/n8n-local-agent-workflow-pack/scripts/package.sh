#!/usr/bin/env bash
# Package n8n-local-agent-workflow-pack into dist/ as a versioned zip.
set -euo pipefail
KIT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="0.1.0"
SKU="n8n-local-agent-workflow-pack"
OUT_DIR="$KIT_DIR/dist"
ZIP_PATH="$OUT_DIR/${SKU}-v${VERSION}.zip"
mkdir -p "$OUT_DIR"
rm -f "$ZIP_PATH"
python3 - "$KIT_DIR" "$ZIP_PATH" "$SKU" <<'PY'
import sys, zipfile
from pathlib import Path
kit_dir, zip_path, sku = Path(sys.argv[1]), Path(sys.argv[2]), sys.argv[3]
exclude = {"__pycache__", ".venv", ".DS_Store", ".pytest_cache", "dist"}
with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
    for path in sorted(kit_dir.rglob("*")):
        if not path.is_file():
            continue
        rel = path.relative_to(kit_dir)
        if any(p in exclude for p in rel.parts):
            continue
        if path.suffix == ".pyc":
            continue
        zf.write(path, f"{sku}/{rel.as_posix()}")
print(f"Created: {zip_path}")
with zipfile.ZipFile(zip_path) as zf:
    print(f"files: {len(zf.namelist())}")
print(f"size_bytes: {zip_path.stat().st_size}")
PY
ls -lh "$ZIP_PATH"
