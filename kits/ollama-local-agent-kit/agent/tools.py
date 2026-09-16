"""
Optional tool stub — demonstrates an extension point without external APIs.

EXTENSION: register real tools (shell, file read with allowlists, HTTP) and
wire them into the chat loop via Ollama tool calling or a manual ReAct loop.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Callable


@dataclass
class Tool:
    name: str
    description: str
    handler: Callable[[str], str]


def echo_tool(arg: str) -> str:
    """Trivial tool: echo the argument. Safe default for demos."""
    return f"echo: {arg}"


def clock_tool(_: str) -> str:
    """Return a UTC timestamp string (no network)."""
    from datetime import datetime, timezone

    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


DEFAULT_TOOLS: dict[str, Tool] = {
    "echo": Tool("echo", "Echo back the argument", echo_tool),
    "clock": Tool("clock", "Return current UTC time", clock_tool),
}


def maybe_run_tool(user_text: str) -> str | None:
    """
    Ultra-simple trigger: if message starts with `/tool NAME ARG...`, run it.
    Returns tool output string, or None if not a tool invocation.
    """
    text = user_text.strip()
    if not text.startswith("/tool "):
        return None
    parts = text.split(maxsplit=2)
    if len(parts) < 2:
        return "usage: /tool <name> [arg]"
    name = parts[1]
    arg = parts[2] if len(parts) > 2 else ""
    tool = DEFAULT_TOOLS.get(name)
    if not tool:
        known = ", ".join(sorted(DEFAULT_TOOLS))
        return f"unknown tool '{name}'. known: {known}"
    return tool.handler(arg)
