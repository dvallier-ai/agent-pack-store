"""
CLI entry: single-shot or interactive chat against local Ollama.

Usage:
  python -m agent.main "Your question"
  python -m agent.main --chat
"""

from __future__ import annotations

import argparse
import sys

from .config import Config
from .ollama_client import OllamaError, chat, ping
from .tools import maybe_run_tool


def build_messages(system: str, history: list[dict[str, str]], user: str) -> list[dict[str, str]]:
    msgs: list[dict[str, str]] = [{"role": "system", "content": system}]
    msgs.extend(history)
    msgs.append({"role": "user", "content": user})
    return msgs


def single_shot(config: Config, prompt: str) -> int:
    tool_out = maybe_run_tool(prompt)
    if tool_out is not None:
        print(tool_out)
        return 0
    if not ping(config):
        print(f"error: Ollama not reachable at {config.host}", file=sys.stderr)
        return 1
    try:
        reply = chat(config, build_messages(config.system, [], prompt))
    except OllamaError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1
    print(reply)
    return 0


def chat_loop(config: Config) -> int:
    if not ping(config):
        print(f"error: Ollama not reachable at {config.host}", file=sys.stderr)
        return 1
    print(f"Ollama Local Agent — model={config.model} host={config.host}")
    print("Type /quit to exit. Tool stub: /tool echo hello | /tool clock")
    history: list[dict[str, str]] = []
    while True:
        try:
            user = input("you> ").strip()
        except (EOFError, KeyboardInterrupt):
            print()
            break
        if not user:
            continue
        if user in ("/quit", "/exit", ":q"):
            break
        tool_out = maybe_run_tool(user)
        if tool_out is not None:
            print(f"tool> {tool_out}")
            continue
        try:
            reply = chat(config, build_messages(config.system, history, user))
        except OllamaError as exc:
            print(f"error: {exc}", file=sys.stderr)
            continue
        print(f"agent> {reply}")
        # EXTENSION: trim history, add summarization, or persist sessions.
        history.append({"role": "user", "content": user})
        history.append({"role": "assistant", "content": reply})
    return 0


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Ollama Local Agent Kit CLI")
    parser.add_argument("prompt", nargs="?", help="Single-shot prompt")
    parser.add_argument("--chat", action="store_true", help="Interactive chat loop")
    args = parser.parse_args(argv)

    config = Config.from_env()
    if args.chat:
        return chat_loop(config)
    if not args.prompt:
        parser.print_help()
        return 2
    return single_shot(config, args.prompt)


if __name__ == "__main__":
    raise SystemExit(main())
