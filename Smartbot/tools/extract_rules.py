#!/usr/bin/env python3
import re, pathlib, os

src = pathlib.Path('ZygorGuidesViewer/Data-Retail/Item-Statweights.lua')
text = src.read_text(encoding='utf-8')

rules = {}
current_class = None
current_spec = None

for line in text.splitlines():
    line = line.strip()
    if not line or line.startswith('--'):
        continue
    m = re.match(r'\["([A-Z]+)"\]\s*=\s*{', line)
    if m:
        current_class = m.group(1)
        rules[current_class] = {}
        continue
    if current_class:
        m = re.match(r'\[(\d+)\]\s*=\s*{', line)
        if m:
            current_spec = int(m.group(1))
            rules[current_class][current_spec] = {'itemtypes': [], 'primary': None}
            continue
        if current_spec:
            if line.startswith('itemtypes'):
                content = line.split('{',1)[1].split('}',1)[0]
                allow = []
                for tok in content.split(','):
                    tok = tok.strip()
                    if not tok:
                        continue
                    key, val = tok.split('=')
                    key = key.strip()
                    try:
                        val = float(val)
                    except ValueError:
                        val = 0
                    if val > 0:
                        allow.append(key)
                rules[current_class][current_spec]['itemtypes'] = allow
                continue
            if line.startswith('primary'):
                content = line.split('{',1)[1].split('}',1)[0]
                primary = None
                for tok in content.split(','):
                    tok = tok.strip()
                    if not tok:
                        continue
                    key, val = tok.split('=')
                    if val.strip() == '1':
                        primary = key.strip()
                rules[current_class][current_spec]['primary'] = primary
                continue
            if line.startswith('}'):
                current_spec = None
                continue
    if current_class and not current_spec and line.startswith('},'):
        current_class = None
        continue

out_lines = [
    "local addonName, Smartbot = ...",
    "Smartbot = Smartbot or {}",
    "-- Data derived from ZygorGuidesViewer/Data-Retail/Item-Statweights.lua (MIT License)",
    "Smartbot.ClassSpecRules = {",
]

for cls in sorted(rules.keys()):
    out_lines.append(f"  ['{cls}'] = {{")
    for spec in sorted(rules[cls].keys()):
        data = rules[cls][spec]
        items = ', '.join(f"{it}=true" for it in data['itemtypes'])
        prim = data['primary'] or 'NONE'
        out_lines.append(f"    [{spec}] = {{ itemtypes={{ {items} }}, primary='{prim}' }},")
    out_lines.append("  },")
out_lines.append("}")

os.makedirs('Smartbot', exist_ok=True)
path_out = pathlib.Path('Smartbot/ClassSpecRules.lua')
path_out.write_text('\n'.join(out_lines), encoding='utf-8')
print('wrote', path_out)
