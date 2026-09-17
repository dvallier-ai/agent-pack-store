#!/usr/bin/env bash
# Build the v0.1.0 Local-LLM Signal Drop zip.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
KIT_DIR="$ROOT/kits/local-llm-signal-drop"
OUT_DIR="$KIT_DIR/dist"
SKU="local-llm-signal-drop"
VERSION="0.1.0"
ZIP_PATH="$OUT_DIR/${SKU}-v${VERSION}.zip"

[[ -d "$KIT_DIR" ]] || { echo "error: kit directory not found: $KIT_DIR" >&2; exit 1; }
mkdir -p "$OUT_DIR"
rm -f "$ZIP_PATH"

python3 - "$KIT_DIR" "$ZIP_PATH" "$SKU" <<'PYTHON'
import sys
import zipfile
from pathlib import Path

kit_dir = Path(sys.argv[1])
zip_path = Path(sys.argv[2])
sku = sys.argv[3]

with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
    for path in sorted(kit_dir.rglob("*")):
        if not path.is_file() or "dist" in path.relative_to(kit_dir).parts:
            continue
        arcname = f"{sku}/{path.relative_to(kit_dir).as_posix()}"
        archive.write(path, arcname)

with zipfile.ZipFile(zip_path) as archive:
    print(f"Created: {zip_path}")
    print(f"files: {len(archive.namelist())}")
print(f"size_bytes: {zip_path.stat().st_size}")
PYTHON
