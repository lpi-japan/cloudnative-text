#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LANG="${1:-ja}"
LANG_DIR="${ROOT_DIR}/${LANG}"
EPUB_CSS="${ROOT_DIR}/epub.css"
OUT_DIR="${ROOT_DIR}/tmp"
GUIDE_MD="${OUT_DIR}/.build-guide-${LANG}.md"
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

if ! command -v pandoc >/dev/null 2>&1 || ! command -v pandoc-crossref >/dev/null 2>&1; then
  exec "${ROOT_DIR}/scripts/with-build-image.sh" "./build-epub.sh" "${LANG}"
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

RESOURCE_PATH="."
for part in "${PART_DIRS[@]}"; do
  if [[ ! -d "${LANG_DIR}/${part}" ]]; then
    echo "missing manuscript directory: ${LANG_DIR}/${part}" >&2
    exit 1
  fi
  RESOURCE_PATH+=":${part}"
done

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

# server-text 等は Chapter*.md を同一ディレクトリに cat するが、cloudnative は
# ja/XX_part/ 配下の ../08_img 参照がある。tmp/ へ結合すると基準パスがずれるため、
# 08_img 参照を言語ディレクトリ基準へ正規化し --resource-path で解決する（build-pdf.sh と同趣旨）。
(
  cd "${LANG_DIR}"
  cat "${inputs[@]}" \
    | sed -e 's/^####.*/#& {-}/' \
          -e 's|(\.\./08_img/|(08_img/|g' \
    > "../${GUIDE_MD#${ROOT_DIR}/}"
)

(
  cd "${LANG_DIR}"
  /usr/bin/awk 'BEGIN{go=0}{ if (go==1){print;} else {if($0 ~ /^#/){ go=1;print;}}}' "../${GUIDE_MD#${ROOT_DIR}/}" \
    | pandoc -t epub3 -F pandoc-crossref -o "../${OUTPUT#${ROOT_DIR}/}" -N \
        -M "crossrefYaml=crossref.yaml" \
        --metadata-file="config-epub.yaml" \
        --css="../epub.css" \
        --resource-path="${RESOURCE_PATH}"
)

echo "Language: ${LANG}"
echo "Output: ${OUTPUT}"
ls -lh "${OUTPUT}"
