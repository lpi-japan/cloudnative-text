#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LANG="${1:-ja}"
LANG_DIR="${ROOT_DIR}/${LANG}"
TEMPLATE="${ROOT_DIR}/template.tex"
CONFIG_COMMON="${ROOT_DIR}/config-common-pdf.yaml"
CONFIG_LANG="${LANG_DIR}/config-pdf.yaml"
IMAGE="${PDF_IMAGE:-ghcr.io/lpi-japan/cloudnative-text:latest}"
BUILD_MODE="${PDF_BUILD_MODE:-docker}"
OUT_DIR="${ROOT_DIR}/tmp"
OUTPUT="${OUT_DIR}/guide-${LANG}.pdf"
CHAPTER_LIST="${OUT_DIR}/.build-chapter-list-${LANG}.txt"

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

usage() {
  echo "Usage: $0 [ja|en]" >&2
  exit 1
}

if [[ "${LANG}" != "ja" && "${LANG}" != "en" ]]; then
  usage
fi

if [[ ! -d "${LANG_DIR}" ]]; then
  echo "language directory not found: ${LANG_DIR}" >&2
  exit 1
fi

if [[ ! -f "${TEMPLATE}" ]]; then
  echo "template.tex not found: ${TEMPLATE}" >&2
  exit 1
fi

if [[ ! -f "${CONFIG_COMMON}" || ! -f "${CONFIG_LANG}" ]]; then
  echo "config not found: ${CONFIG_COMMON} and/or ${CONFIG_LANG}" >&2
  exit 1
fi

cd "${ROOT_DIR}"
mkdir -p "${OUT_DIR}"

RESOURCE_PATH="${LANG_DIR}"
for part in "${PART_DIRS[@]}"; do
  if [[ ! -d "${LANG_DIR}/${part}" ]]; then
    echo "missing manuscript directory: ${LANG_DIR}/${part}" >&2
    exit 1
  fi
  RESOURCE_PATH+=":${LANG_DIR}/${part}"
done

if [[ ! -f "${LANG_DIR}/preface.md" ]]; then
  echo "missing ${LANG_DIR}/preface.md" >&2
  exit 1
fi

chapters=()
: > "${CHAPTER_LIST}"
for part in "${PART_DIRS[@]}"; do
  while IFS= read -r -d '' f; do
    chapters+=("${f}")
    printf '%s\n' "${f}" >> "${CHAPTER_LIST}"
  done < <(find "${LANG_DIR}/${part}" -maxdepth 1 -type f -name '*.md' -print0 | LC_ALL=C sort -z)
done

if ((${#chapters[@]} == 0)); then
  echo "no manuscript markdown files found under ${LANG_DIR}" >&2
  exit 1
fi

run_pandoc() {
  mapfile -t chapters < "${CHAPTER_LIST}"

  pandoc "${LANG_DIR}/preface.md" -o "tmp/preface-${LANG}.tex" --resource-path="${RESOURCE_PATH}"
  printf '%s\0' "${chapters[@]}" | xargs -0 pandoc \
    -d "${CONFIG_COMMON}" \
    -d "${CONFIG_LANG}" \
    --template "${TEMPLATE}" \
    --resource-path="${RESOURCE_PATH}" \
    -B "tmp/preface-${LANG}.tex" \
    -M "no-cover=true" \
    -o "${OUTPUT}"
}

if [[ "${BUILD_MODE}" == "direct" ]]; then
  run_pandoc
else
  docker run --rm -i \
    --user "$(id -u):$(id -g)" \
    -e LANG="${LANG}" \
    -e LANG_DIR="/data/${LANG}" \
    -e CONFIG_COMMON="/data/config-common-pdf.yaml" \
    -e CONFIG_LANG="/data/${LANG}/config-pdf.yaml" \
    -e OUTPUT="${OUTPUT}" \
    -e RESOURCE_PATH="${RESOURCE_PATH}" \
    -e TEMPLATE="/data/template.tex" \
    -v "${ROOT_DIR}:/data" \
    -w /data \
    --entrypoint /bin/bash \
    "${IMAGE}" -s <<'EOF'
set -euo pipefail

mapfile -t chapters < "tmp/.build-chapter-list-${LANG}.txt"

pandoc "${LANG_DIR}/preface.md" -o "tmp/preface-${LANG}.tex" --resource-path="${RESOURCE_PATH}"
printf '%s\0' "${chapters[@]}" | xargs -0 pandoc \
  -d "${CONFIG_COMMON}" \
  -d "${CONFIG_LANG}" \
  --template "${TEMPLATE}" \
  --resource-path="${RESOURCE_PATH}" \
  -B "tmp/preface-${LANG}.tex" \
  -M "no-cover=true" \
  -o "${OUTPUT}"
EOF
fi

echo "Language: ${LANG}"
echo "Config: ${CONFIG_COMMON} + ${CONFIG_LANG}"
echo "Build mode: ${BUILD_MODE}"
echo "Image: ${IMAGE}"
echo "Resource path: ${RESOURCE_PATH}"
echo "Output: ${OUTPUT}"
echo "Chapters (${CHAPTER_LIST}):"
nl -ba "${CHAPTER_LIST}"
ls -lh "${OUTPUT}"
