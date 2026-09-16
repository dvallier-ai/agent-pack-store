"""
Run fixture prompts against local Ollama; write report.json + report.md.

Heuristics:
  - response non-empty
  - latency under per-fixture (or global) max seconds
  - if expect_keyword set, case-insensitive substring match
"""

from __future__ import annotations

import json
import os
import shutil
import sys
import time
from pathlib import Path

# Allow `python -m eval.harness` from kit root
ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from agent.config import Config
from agent.ollama_client import OllamaError, chat, ping


def load_fixtures(path: Path) -> list[dict]:
    with path.open(encoding="utf-8") as f:
        data = json.load(f)
    if not isinstance(data, list) or not data:
        raise SystemExit(f"No fixtures in {path}")
    return data


def run_one(config: Config, fixture: dict, global_max: float) -> dict:
    fid = fixture.get("id", "unknown")
    prompt = fixture["prompt"]
    expect = fixture.get("expect_keyword")
    max_lat = float(fixture.get("max_latency_sec") or global_max)

    started = time.perf_counter()
    error = None
    response = ""
    try:
        messages = [
            {"role": "system", "content": config.system},
            {"role": "user", "content": prompt},
        ]
        response = chat(config, messages)
    except OllamaError as exc:
        error = str(exc)
    latency = time.perf_counter() - started

    checks = {
        "non_empty": bool(response and response.strip()),
        "latency_ok": latency <= max_lat and error is None,
        "keyword_ok": True,
    }
    if expect:
        checks["keyword_ok"] = expect.lower() in (response or "").lower()

    passed = all(checks.values()) and error is None
    return {
        "id": fid,
        "prompt": prompt,
        "expect_keyword": expect,
        "max_latency_sec": max_lat,
        "latency_sec": round(latency, 3),
        "response": response,
        "error": error,
        "checks": checks,
        "pass": passed,
    }


def write_reports(results: list[dict], out_dir: Path) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)
    summary = {
        "total": len(results),
        "passed": sum(1 for r in results if r["pass"]),
        "failed": sum(1 for r in results if not r["pass"]),
        "results": results,
    }
    json_path = out_dir / "report.json"
    md_path = out_dir / "report.md"
    with json_path.open("w", encoding="utf-8") as f:
        json.dump(summary, f, indent=2)
        f.write("\n")

    lines = [
        "# Eval report — Ollama Local Agent Kit",
        "",
        f"- Total: {summary['total']}",
        f"- Passed: {summary['passed']}",
        f"- Failed: {summary['failed']}",
        "",
        "| id | pass | latency_s | keyword | notes |",
        "|----|------|-----------|---------|-------|",
    ]
    for r in results:
        notes = r["error"] or ("ok" if r["pass"] else "check failed")
        kw = r["expect_keyword"] or "—"
        lines.append(
            f"| {r['id']} | {'PASS' if r['pass'] else 'FAIL'} | "
            f"{r['latency_sec']} | {kw} | {notes} |"
        )
        lines.append("")
        lines.append(f"### {r['id']}")
        lines.append("")
        lines.append(f"**Prompt:** {r['prompt']}")
        lines.append("")
        lines.append("**Response:**")
        lines.append("")
        lines.append("```")
        lines.append((r["response"] or r["error"] or "(empty)")[:2000])
        lines.append("```")
        lines.append("")

    md_path.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {json_path}")
    print(f"Wrote {md_path}")
    print(f"Summary: {summary['passed']}/{summary['total']} passed")


def main() -> int:
    fixtures_path = Path(__file__).parent / "fixtures" / "prompts.json"
    out_dir = Path(__file__).parent
    config = Config.from_env()
    global_max = float(os.environ.get("EVAL_MAX_LATENCY_SEC", "30"))

    if not ping(config):
        if shutil.which("ollama") is None:
            availability_error = (
                f"Ollama is not installed or not on PATH (checked {config.host}). "
                "Install from https://ollama.com/download, then run `ollama serve` "
                "and `./scripts/pull-model.sh`."
            )
        else:
            availability_error = (
                f"Ollama is not reachable at {config.host}. "
                "Start it with `ollama serve`, then run `./scripts/pull-model.sh`."
            )
        print(f"error: {availability_error}", file=sys.stderr)
        # Still write a failed report so CI/scripts have artifacts
        fixtures = load_fixtures(fixtures_path)
        results = [
            {
                "id": fx.get("id", "unknown"),
                "prompt": fx["prompt"],
                "expect_keyword": fx.get("expect_keyword"),
                "max_latency_sec": float(fx.get("max_latency_sec") or global_max),
                "latency_sec": 0.0,
                "response": "",
                "error": availability_error,
                "checks": {"non_empty": False, "latency_ok": False, "keyword_ok": False},
                "pass": False,
            }
            for fx in fixtures
        ]
        write_reports(results, out_dir)
        return 1

    fixtures = load_fixtures(fixtures_path)
    results = [run_one(config, fx, global_max) for fx in fixtures]
    write_reports(results, out_dir)
    return 0 if all(r["pass"] for r in results) else 2


if __name__ == "__main__":
    raise SystemExit(main())
