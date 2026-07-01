#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LANG="${1:-ja}"
LANG_DIR="${ROOT_DIR}/${LANG}"
EPUB_CSS="${ROOT_DIR}/epub.css"
IMAGE="${EPUB_IMAGE:-ghcr.io/lpi-japan/cloudnative-text:latest}"
BUILD_MODE="${EPUB_BUILD_MODE:-docker}"
OUT_DIR="${ROOT_DIR}/tmp"
GUIDE_MD="${OUT_DIR}/guide-${LANG}.md"
OUTPUT="${OUT_DIR}/guide-${LANG}.epub"

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

if [[ ! -f "${LANG_DIR}/config-epub.yaml" || ! -f "${LANG_DIR}/crossref.yaml" || ! -f "${EPUB_CSS}" ]]; then
  echo "missing epub config under ${LANG_DIR} or ${EPUB_CSS}" >&2
  exit 1
fi

mkdir -p "${OUT_DIR}"

inputs=("preface.md")
for part in "${PART_DIRS[@]}"; do
  while IFS= read -r -d '' f; do
    inputs+=("${f#${LANG_DIR}/}")
  done < <(find "${LANG_DIR}/${part}" -maxdepth 1 -type f -name '*.md' -print0 | LC_ALL=C sort -z)
done

if ((${#inputs[@]} < 2)); then
  echo "no manuscript markdown files found under ${LANG_DIR}" >&2
  exit 1
fi

(
  cd "${LANG_DIR}"
  cat "${inputs[@]}" | sed 's/^####.*/#& {-}/' > "../${GUIDE_MD#${ROOT_DIR}/}"
)

run_pandoc() {
  (
    cd "${LANG_DIR}"
    /usr/bin/awk 'BEGIN{go=0}{ if (go==1){print;} else {if($0 ~ /^#/){ go=1;print;}}}' "../${GUIDE_MD#${ROOT_DIR}/}" \
      | pandoc -t epub3 -F pandoc-crossref -o "../${OUTPUT#${ROOT_DIR}/}" -N \
          -M "crossrefYaml=crossref.yaml" \
          --metadata-file="config-epub.yaml" \
          --css="../epub.css"
  )
}

if [[ "${BUILD_MODE}" == "direct" ]]; then
  run_pandoc
else
  docker run --rm -i \
    -e LANG="${LANG}" \
    -v "${ROOT_DIR}:/data" \
    -w /data \
    --entrypoint /bin/bash \
    "${IMAGE}" -s <<'EOF'
set -euo pipefail

(
  cd "${LANG}"
  /usr/bin/awk 'BEGIN{go=0}{ if (go==1){print;} else {if($0 ~ /^#/){ go=1;print;}}}' "../tmp/guide-${LANG}.md" \
    | pandoc -t epub3 -F pandoc-crossref -o "../tmp/guide-${LANG}.epub" -N \
        -M "crossrefYaml=crossref.yaml" \
        --metadata-file="config-epub.yaml" \
        --css="../epub.css"
)
EOF
fi

echo "Language: ${LANG}"
echo "Build mode: ${BUILD_MODE}"
echo "Image: ${IMAGE}"
echo "Output: ${OUTPUT}"
ls -lh "${OUTPUT}"
