#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
WORK_DIR="${SCRIPT_DIR}"
BUILD_DIR="${WORK_DIR}/build"
TEMPLATE_DIR="${ROOT_DIR}/../../text-manage/server-text"
IMAGE="ghcr.io/lpi-japan/server-text:latest"

if [[ ! -f "${TEMPLATE_DIR}/template.tex" ]]; then
  echo "template.tex not found: ${TEMPLATE_DIR}/template.tex" >&2
  exit 1
fi

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

export ROOT_DIR BUILD_DIR
python3 - <<'PY'
from pathlib import Path
import os
import re

root_dir = Path(os.environ['ROOT_DIR'])
build_dir = Path(os.environ['BUILD_DIR'])
part_dirs = [
    '00_prologue',
    '01_part1-basics',
    '02_part2-practice',
    '03_part3-application',
    '04_part4-operation',
    '05_part5-development',
    '06_part6-summary',
    '07_appendix-doorway-to-practice',
]
placeholder_pat = re.compile(r'<([A-Z][A-Z0-9_-]*)>')
amp_pat = re.compile(r'&(?!#?[0-9A-Za-z]+;)')

files = []
for part in part_dirs:
    part_path = root_dir / part
    if not part_path.is_dir():
        raise SystemExit(f'missing manuscript directory: {part_path}')
    files.extend(sorted(part_path.glob('*.md')))

if not files:
    raise SystemExit('no markdown files found')

manifest = []
for idx, src in enumerate(files, 1):
    text = src.read_text(encoding='utf-8')
    lines = []
    in_fence = False
    for line in text.splitlines():
        if line.startswith('```'):
            in_fence = not in_fence
            lines.append(line)
            continue
        if not in_fence:
            if line.strip() == '---':
                lines.append('* * *')
                continue
            line = line.replace('](../08_img/', '](/src/08_img/')
            line = line.replace('(../08_img/', '(/src/08_img/')
            line = placeholder_pat.sub(r'&lt;\1&gt;', line)
            line = amp_pat.sub('&amp;', line)
        lines.append(line)
    out = build_dir / f'{idx:03d}.md'
    out.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    manifest.append(f'{out.name}\t{src.relative_to(root_dir)}')
(build_dir / 'manifest.tsv').write_text('\n'.join(manifest) + '\n', encoding='utf-8')
print(f'prepared {len(files)} chapters')
PY

docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "${ROOT_DIR}:/src:ro" \
  -v "${WORK_DIR}:/work" \
  -v "${TEMPLATE_DIR}:/server-text:ro" \
  -w /work \
  --entrypoint /bin/sh \
  "${IMAGE}" \
  -c 'set -eu; find /work/build -maxdepth 1 -type f -name "*.md" -print0 | LC_ALL=C sort -z | xargs -0 pandoc -d /work/config-pdf.yaml --template /server-text/template.tex --resource-path=/src:/work/build -M no-cover=true -o /work/guide.pdf'

ls -lh "${WORK_DIR}/guide.pdf"
