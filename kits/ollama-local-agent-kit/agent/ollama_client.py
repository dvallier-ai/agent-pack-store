"""Thin Ollama HTTP client (stdlib + optional requests)."""

from __future__ import annotations

import json
import urllib.error
import urllib.request
from typing import Any

from .config import Config


class OllamaError(RuntimeError):
    pass


def chat(config: Config, messages: list[dict[str, str]], stream: bool = False) -> str:
    """
    Call POST /api/chat and return the assistant message content.

    EXTENSION: switch to /api/generate, add streaming callbacks, or tool calling
    by extending the payload and parsing message.tool_calls.
    """
    url = f"{config.host}/api/chat"
    payload: dict[str, Any] = {
        "model": config.model,
        "messages": messages,
        "stream": stream,
    }
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=data,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=config.timeout_sec) as resp:
            body = resp.read().decode("utf-8")
    except urllib.error.URLError as exc:
        raise OllamaError(
            f"Cannot reach Ollama at {config.host}: {exc}. Is `ollama serve` running?"
        ) from exc

    try:
        parsed = json.loads(body)
    except json.JSONDecodeError as exc:
        raise OllamaError(f"Invalid JSON from Ollama: {body[:200]}") from exc

    message = parsed.get("message") or {}
    content = message.get("content")
    if not content:
        raise OllamaError(f"Empty response from model: {parsed!r}")
    return str(content).strip()


def ping(config: Config) -> bool:
    """Return True if /api/tags is reachable."""
    url = f"{config.host}/api/tags"
    try:
        with urllib.request.urlopen(url, timeout=5) as resp:
            return 200 <= resp.status < 300
    except Exception:
        return False
