#!/usr/bin/env python3
"""Verify header.jsp i18n keys exist in all locale bundles.

Usage:
  python scripts/check_i18n_keys.py
"""
from __future__ import annotations

from pathlib import Path
import re
import sys


HEADER_PATH = Path("src/main/webapp/WEB-INF/views/common/header.jsp")
MESSAGE_FILES = {
    "ko": Path("src/main/resources/message/messageSource_ko.properties"),
    "en": Path("src/main/resources/message/messageSource_en.properties"),
    "jp": Path("src/main/resources/message/messageSource_jp.properties"),
}


def load_header_keys() -> list[str]:
    content = HEADER_PATH.read_text(encoding="utf-8")
    keys = re.findall(r"code='([^']+)'", content)
    return sorted({key for key in keys if not key.startswith("${")})


def load_properties(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def main() -> int:
    missing: dict[str, list[str]] = {lang: [] for lang in MESSAGE_FILES}
    keys = load_header_keys()

    for lang, path in MESSAGE_FILES.items():
        if not path.exists():
            print(f"Missing properties file: {path}")
            return 2

        content = load_properties(path)
        for key in keys:
            if key not in content:
                missing[lang].append(key)

    failures = {lang: keys for lang, keys in missing.items() if keys}
    if failures:
        for lang, keys in failures.items():
            print(f"Missing keys for {lang} ({len(keys)}):")
            for key in keys:
                print(f"  - {key}")
        return 1

    print(f"OK: {len(keys)} keys present in all locale bundles.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
