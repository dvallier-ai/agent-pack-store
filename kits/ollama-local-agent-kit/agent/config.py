"""Configuration from environment (no secrets required for local Ollama)."""

from __future__ import annotations

import os
from dataclasses import dataclass


@dataclass(frozen=True)
class Config:
    host: str
    model: str
    system: str
    timeout_sec: float

    @classmethod
    def from_env(cls) -> "Config":
        # EXTENSION: load a .env file here with python-dotenv if you prefer.
        return cls(
            host=os.environ.get("OLLAMA_HOST", "http://127.0.0.1:11434").rstrip("/"),
            model=os.environ.get("OLLAMA_MODEL", "llama3.2:1b"),
            system=os.environ.get(
                "AGENT_SYSTEM",
                "You are a concise local engineering assistant. Prefer short, accurate answers.",
            ),
            timeout_sec=float(os.environ.get("OLLAMA_TIMEOUT_SEC", "120")),
        )
