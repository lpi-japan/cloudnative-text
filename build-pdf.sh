#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="${ROOT_DIR}/../../text-manage/server-text"
IMAGE="ghcr.io/lpi-japan/server-text:latest"

# git 管理の英語原稿ディレクトリ（doc-phase 版と同じ明示リスト）
PART_DIRS=(
  00_prologue
  01_part1-basics
  02_part2-practice
  03_part3-application
  04_part4-operation
  05_part5-development
  06_part6-summary
  07_appendix-doorway-to-practice
)

if [[ ! -f "${TEMPLATE_DIR}/template.tex" ]]; then
  echo "template.tex not found: ${TEMPLATE_DIR}/template.tex" >&2
  exit 1
fi

cd "${ROOT_DIR}"

for part in "${PART_DIRS[@]}"; do
  if [[ ! -d "${part}" ]]; then
    echo "missing manuscript directory: ${part}" >&2
    exit 1
  fi
done

docker run --rm -i \
  --user "$(id -u):$(id -g)" \
  -v "${ROOT_DIR}:/data" \
  -v "${TEMPLATE_DIR}:/server-text:ro" \
  -w /data \
  --entrypoint /bin/bash \
  "${IMAGE}" -s <<'EOF'
set -euo pipefail

part_dirs=(
  00_prologue
  01_part1-basics
  02_part2-practice
  03_part3-application
  04_part4-operation
  05_part5-development
  06_part6-summary
  07_appendix-doorway-to-practice
)

chapters=()
for part in "${part_dirs[@]}"; do
  while IFS= read -r -d '' f; do
    chapters+=("$f")
  done < <(find "./${part}" -maxdepth 1 -type f -name '*.md' -print0 | LC_ALL=C sort -z)
done

if ((${#chapters[@]} == 0)); then
  echo "no manuscript markdown files found" >&2
  exit 1
fi

printf '%s\n' "${chapters[@]}" > /data/.build-chapter-list.txt
printf '%s\0' "${chapters[@]}" | xargs -0 pandoc \
  -d config-pdf.yaml \
  --template /server-text/template.tex \
  --resource-path=. \
  -M no-cover=true \
  -o guide.pdf
EOF

echo "Chapters (${ROOT_DIR}/.build-chapter-list.txt):"
nl -ba "${ROOT_DIR}/.build-chapter-list.txt"
ls -lh "${ROOT_DIR}/guide.pdf"
