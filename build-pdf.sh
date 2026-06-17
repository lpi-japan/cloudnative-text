#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="${ROOT_DIR}/../../text-manage/server-text"
IMAGE="ghcr.io/lpi-japan/server-text:latest"
CONFIG="config-pdf.yaml"
OUTPUT="guide.pdf"
CHAPTER_LIST="${ROOT_DIR}/.build-chapter-list.txt"

# git 管理の原稿ディレクトリ（部ごとに 1 列）
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

RESOURCE_PATH="."
for part in "${PART_DIRS[@]}"; do
  if [[ ! -d "${part}" ]]; then
    echo "missing manuscript directory: ${part}" >&2
    exit 1
  fi
  RESOURCE_PATH+=":${part}"
done

if [[ ! -f preface.md ]]; then
  echo "missing preface.md" >&2
  exit 1
fi

chapters=()
: > "${CHAPTER_LIST}"
for part in "${PART_DIRS[@]}"; do
  while IFS= read -r -d '' f; do
    chapters+=("${f}")
    printf '%s\n' "${f}" >> "${CHAPTER_LIST}"
  done < <(find "./${part}" -maxdepth 1 -type f -name '*.md' -print0 | LC_ALL=C sort -z)
done

if ((${#chapters[@]} == 0)); then
  echo "no manuscript markdown files found" >&2
  exit 1
fi

docker run --rm -i \
  --user "$(id -u):$(id -g)" \
  -e CONFIG="${CONFIG}" \
  -e OUTPUT="${OUTPUT}" \
  -e RESOURCE_PATH="${RESOURCE_PATH}" \
  -v "${ROOT_DIR}:/data" \
  -v "${TEMPLATE_DIR}:/server-text:ro" \
  -w /data \
  --entrypoint /bin/bash \
  "${IMAGE}" -s <<'EOF'
set -euo pipefail

mapfile -t chapters < .build-chapter-list.txt

pandoc preface.md -o preface.tex --resource-path="${RESOURCE_PATH}"
printf '%s\0' "${chapters[@]}" | xargs -0 pandoc \
  -d "${CONFIG}" \
  --template /server-text/template.tex \
  --resource-path="${RESOURCE_PATH}" \
  -B preface.tex \
  -M no-cover=true \
  -o "${OUTPUT}"
EOF

echo "Config: ${CONFIG}"
echo "Resource path: ${RESOURCE_PATH}"
echo "Output: ${OUTPUT}"
echo "Chapters (${CHAPTER_LIST}):"
nl -ba "${CHAPTER_LIST}"
ls -lh "${ROOT_DIR}/${OUTPUT}"
