#!/usr/bin/env python3
"""Reads `xcrun simctl list devices available -j` on stdin and prints the UDID of the
newest iPhone Pro Max (argument `max`) or non-Max iPhone Pro (argument `pro`) on the
newest iOS runtime, then its name and runtime."""
import json
import re
import sys

want_max = len(sys.argv) > 1 and sys.argv[1] == "max"
devices = json.load(sys.stdin)["devices"]
best = None
for runtime, sims in devices.items():
    match = re.search(r"iOS-(\d+)-(\d+)", runtime)
    if not match:
        continue
    version = (int(match.group(1)), int(match.group(2)))
    for sim in sims:
        name = sim.get("name", "")
        if not sim.get("isAvailable", True) or not name.startswith("iPhone") or "Pro" not in name:
            continue
        if ("Max" in name) != want_max:
            continue
        number = int((re.search(r"iPhone (\d+)", name) or [0, 0])[1] or 0)
        key = (version, number, name)
        if best is None or key > best[0]:
            best = (key, sim["udid"], name, runtime)

if best is None:
    sys.exit("No matching iPhone simulator available")
print(best[1])
print(best[2])
print(best[3])
