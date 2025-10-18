#!/usr/bin/env python3
"""Simple YAML validator across workspace YAML files.
Usage: python yaml_validate.py
"""
from ruamel.yaml import YAML
from pathlib import Path
import sys

Y = YAML(typ='safe')

root = Path(__file__).resolve().parent
patterns = ['**/*.yml', '**/*.yaml']

files = []
for p in patterns:
    files.extend(sorted(root.glob(p)))

if not files:
    print('No YAML files found')
    sys.exit(0)

# Skip common virtualenv and vendor folders
skip_parts = {'.venv', 'venv', '.dbt', 'node_modules', 'site-packages'}
errors = []
skipped = []
checked = 0
for f in files:
    if any(part in skip_parts for part in f.parts):
        skipped.append(str(f.relative_to(root)))
        continue
    try:
        with f.open('r', encoding='utf-8') as fh:
            Y.load(fh)
        checked += 1
    except Exception as e:
        errors.append((str(f.relative_to(root)), str(e)))

print(f'Checked {checked} YAML files (skipped {len(skipped)} files)')
if skipped:
    print('Skipped files:')
    for s in skipped:
        print(f'- {s}')

if not errors:
    print('All validated YAML files parsed successfully')
    sys.exit(0)
else:
    print(f'Found {len(errors)} file(s) with errors:')
    for fn, err in errors:
        print(f'- {fn}: {err}')
    sys.exit(2)
