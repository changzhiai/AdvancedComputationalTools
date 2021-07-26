import json
from pathlib import Path
from sys import argv


def convert(path):
    assert path.name.endswith('.master.ipynb')
    data = json.loads(path.read_text())
    for cell in data['cells']:
        if cell['cell_type'] == 'code':
            lines = cell['source']
            for i, line in enumerate(lines):
                if ' # student:' in line:
                    a, b = (x.strip() for x in line.split('# student:'))
                    lines[i] = line.split(a)[0] + b + '\n'
                elif line.lower().startswith('# teacher'):
                    del lines[i:]
                    break
    new = path.with_name(path.name.rsplit('.', 2)[0] + '.ipynb')
    new.write_text(json.dumps(data, indent=1))


for path in Path(argv[1]).glob('*.master.ipynb'):
    print(path)
    convert(path)
