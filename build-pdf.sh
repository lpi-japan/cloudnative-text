#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="${ROOT_DIR}/template.tex"
IMAGE="${PDF_IMAGE:-ghcr.io/lpi-japan/cloudnative-text:latest}"
BUILD_MODE="${PDF_BUILD_MODE:-docker}"
CONFIG="config-pdf.yaml"
OUT_DIR="${ROOT_DIR}/tmp"
OUTPUT="tmp/guide.pdf"
CHAPTER_LIST="${OUT_DIR}/.build-chapter-list.txt"

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

if [[ ! -f "${TEMPLATE}" ]]; then
  echo "template.tex not found: ${TEMPLATE}" >&2
  exit 1
fi

cd "${ROOT_DIR}"
mkdir -p "${OUT_DIR}"

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

run_pandoc() {
  mapfile -t chapters < tmp/.build-chapter-list.txt

  pandoc preface.md -o tmp/preface.tex --resource-path="${RESOURCE_PATH}"
  printf '%s\0' "${chapters[@]}" | xargs -0 pandoc \
    -d "${CONFIG}" \
    --template "${TEMPLATE}" \
    --resource-path="${RESOURCE_PATH}" \
    -B tmp/preface.tex \
    -M no-cover=true \
    -o "${OUTPUT}"
}

if [[ "${BUILD_MODE}" == "direct" ]]; then
  run_pandoc
else
  docker run --rm -i \
    --user "$(id -u):$(id -g)" \
    -e CONFIG="${CONFIG}" \
    -e OUTPUT="${OUTPUT}" \
    -e RESOURCE_PATH="${RESOURCE_PATH}" \
    -e TEMPLATE="/data/template.tex" \
    -v "${ROOT_DIR}:/data" \
    -w /data \
    --entrypoint /bin/bash \
    "${IMAGE}" -s <<'EOF'
set -euo pipefail

mapfile -t chapters < tmp/.build-chapter-list.txt

pandoc preface.md -o tmp/preface.tex --resource-path="${RESOURCE_PATH}"
printf '%s\0' "${chapters[@]}" | xargs -0 pandoc \
  -d "${CONFIG}" \
  --template "${TEMPLATE}" \
  --resource-path="${RESOURCE_PATH}" \
  -B tmp/preface.tex \
  -M no-cover=true \
  -o "${OUTPUT}"
EOF
fi

echo "Config: ${CONFIG}"
echo "Build mode: ${BUILD_MODE}"
echo "Image: ${IMAGE}"
echo "Resource path: ${RESOURCE_PATH}"
echo "Output: ${OUT_DIR}/guide.pdf"
echo "Chapters (${CHAPTER_LIST}):"
nl -ba "${CHAPTER_LIST}"
ls -lh "${OUT_DIR}/guide.pdf"
