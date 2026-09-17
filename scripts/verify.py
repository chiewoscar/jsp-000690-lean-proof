#!/usr/bin/env python3
"""Reproduce the Lean and combinatorial checks for the submission package."""
from __future__ import annotations

import argparse
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FORBIDDEN = re.compile(r"\b(sorry|admit|axiom|unsafe|implemented_by|native_decide)\b")
SOURCES = [ROOT / "JSP000690.lean", ROOT / "JSP000690" / "Basic.lean"]


def run(cmd: list[str], log: Path | None = None) -> None:
    proc = subprocess.run(cmd, cwd=ROOT, text=True, encoding="utf-8",
                          errors="replace", stdout=subprocess.PIPE,
                          stderr=subprocess.STDOUT)
    if log is not None:
        log.write_text(proc.stdout, encoding="utf-8")
    print(proc.stdout, end="")
    if proc.returncode:
        raise SystemExit(proc.returncode)


def source_audit() -> None:
    for path in SOURCES:
        text = path.read_text(encoding="utf-8")
        # Strip comments before scanning, so docs can discuss forbidden tokens.
        text = re.sub(r"/-.*?-/", "", text, flags=re.S)
        text = re.sub(r"--.*", "", text)
        hit = FORBIDDEN.search(text)
        if hit:
            raise SystemExit(f"forbidden proof construct in {path.name}: {hit.group(1)}")
    print("source audit: PASS")


def main() -> None:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    parser = argparse.ArgumentParser()
    parser.add_argument("--certificate-only", action="store_true")
    args = parser.parse_args()

    source_audit()
    run([sys.executable, "scripts/check_certificate.py"])

    status = {
        "source_audit": "pass",
        "certificate": "pass",
        "lean_build": "not-run",
        "statement_axiom_audit": "not-run",
    }
    (ROOT / "verification").mkdir(exist_ok=True)
    if not args.certificate_only:
        if shutil.which("lake") is None:
            raise SystemExit("lake is not installed; rerun with "
                             "--certificate-only or install the pinned toolchain")
        run(["lake", "build"], ROOT / "verification" / "local-lake-build.log")
        status["lean_build"] = "pass"
        run(["lake", "env", "lean", "StatementAudit.lean"],
            ROOT / "verification" / "local-statement-audit.log")
        status["statement_axiom_audit"] = "pass"

    (ROOT / "verification" / "status.json").write_text(
        json.dumps(status, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
