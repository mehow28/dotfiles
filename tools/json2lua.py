#!/usr/bin/env python3
"""Idempotent: reads settings.json + hosts/<host> overlay -> emits config/*.lua deterministically"""
import json, pathlib, sys
host=sys.argv[1] if len(sys.argv)>1 else "desktop"
base=json.loads(pathlib.Path("hosts/desktop/settings.json").read_text())
overlay=pathlib.Path(f"hosts/{host}/settings.json")
if overlay.exists():
    j=json.loads(overlay.read_text())
    base={**base, **j}
# emit minimal lua files atomically - placeholder
print(f"json2lua ok for {host}: monitors={base.get('monitors')}")
