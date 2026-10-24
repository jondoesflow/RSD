#!/usr/bin/env python3
"""Copies screenshots exported by `xcresulttool export attachments` into
shots/<size>/<name>.png, using the names given in the UI test."""
import json
import pathlib
import shutil
import sys

size = sys.argv[1]
src = pathlib.Path("export") / size
dest = pathlib.Path("shots") / size
dest.mkdir(parents=True, exist_ok=True)
for test in json.loads((src / "manifest.json").read_text()):
    for attachment in test.get("attachments", []):
        name = attachment.get("suggestedHumanReadableName") or attachment["exportedFileName"]
        name = name.split("_0_")[0].rsplit(".", 1)[0] + ".png"
        shutil.copy(src / attachment["exportedFileName"], dest / name)
print(sorted(p.name for p in dest.iterdir()))
