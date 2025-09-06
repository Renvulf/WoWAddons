#!/usr/bin/env python3
import json, re, os, pathlib

roots = ['ZygorGuidesViewer', 'Details']
pattern = re.compile(r'\b([A-Z][A-Za-z0-9_]*(?:\.[A-Z][A-Za-z0-9_]*)*)\s*\(')

symbols = {}

for root in roots:
    for path in pathlib.Path(root).rglob('*.lua'):
        try:
            with open(path, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()
        except Exception:
            continue
        for line in lines:
            for match in pattern.finditer(line):
                full = match.group(1)
                base = full.split('.')[-1]
                sym = symbols.setdefault(base, {})
                cand = sym.setdefault(full, {'count':0, 'sample': line.strip(), 'files': []})
                cand['count'] += 1
                if len(cand['files']) < 3:
                    cand['files'].append(str(path))

output = {'symbols': {}}

os.makedirs('Smartbot/.cache', exist_ok=True)

lua_lines = ['Smartbot = Smartbot or {}', 'Smartbot.APIMap = {']

for base, cands in symbols.items():
    output['symbols'][base] = []
    lua_lines.append("  ['{}'] = {{".format(base))
    for name, info in cands.items():
        count = info['count']
        conf = min(1.0, count/5)
        entry = {'name': name, 'count': count, 'confidence': round(conf,2), 'sample': info['sample'], 'retail': True}
        output['symbols'][base].append(entry)
        sample = info['sample'].replace("'", "\'")
        lua_lines.append("    {name='%s', count=%d, confidence=%.2f, sample='%s'}," % (name, count, conf, sample))
    lua_lines.append('  },')

lua_lines.append('}')

with open('Smartbot/.cache/retail_api_map.json', 'w', encoding='utf-8') as f:
    json.dump(output, f, indent=2)

with open('Smartbot/APIMap.lua', 'w', encoding='utf-8') as f:
    f.write('\n'.join(lua_lines))
