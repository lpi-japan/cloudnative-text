#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LANG="${1:-ja}"
LANG_DIR="${ROOT_DIR}/${LANG}"
EPUB_CSS="${ROOT_DIR}/epub.css"
OUT_DIR="${ROOT_DIR}/tmp"
OUTPUT="${OUT_DIR}/cloudnativetext_${LANG}.epub"
HL_CSS_KINDLE="${OUT_DIR}/.highlighting-kindle.css"
CHAPTER_LIST="${OUT_DIR}/.build-epub-chapter-list-${LANG}.txt"

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

COVER_IMAGE="${LANG_DIR}/image/Cover/電子版表紙_300dpi_2480x3508.png"
if [[ ! -f "${COVER_IMAGE}" ]]; then
  echo "missing cover image: ${COVER_IMAGE}" >&2
  exit 1
fi

if [[ ! -f "${LANG_DIR}/preface.md" ]]; then
  echo "missing ${LANG_DIR}/preface.md" >&2
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

# PDF と同様、原稿を結合せず複数入力で渡す。
# pandoc がファイル間に空行を入れるため blank_before_header 問題も起きない。
# ../08_img は --resource-path（言語ルート + 各部）で解決する。
inputs=("preface.md")
: > "${CHAPTER_LIST}"
for part in "${PART_DIRS[@]}"; do
  while IFS= read -r -d '' f; do
    rel="${f#${LANG_DIR}/}"
    inputs+=("${rel}")
    printf '%s\n' "${rel}" >> "${CHAPTER_LIST}"
  done < <(find "${LANG_DIR}/${part}" -maxdepth 1 -type f -name '*.md' -print0 | LC_ALL=C sort -z)
done

if ((${#inputs[@]} < 2)); then
  echo "no manuscript markdown files found under ${LANG_DIR}" >&2
  exit 1
fi

# Pandoc embeds skylighting CSS via $highlighting-css$ with:
#   pre > code.sourceCode > span { display: inline-block; ... }
# Kindle Previewer doubles those lines (pandoc#8528). External --css does not
# override it there. Pass a patched stylesheet through -V so the embedded
# <style> is correct at pandoc write time (no post-EPUB rewrite).
prepare_kindle_highlighting_css() {
  local sample_md hl_tpl hl_default
  sample_md="${OUT_DIR}/.hl-sample.md"
  hl_tpl="${OUT_DIR}/.hl-extract.tpl"
  hl_default="${OUT_DIR}/.highlighting-default.css"
  printf '%s\n' '```bash' 'x' '```' > "${sample_md}"
  printf '%s\n' '$highlighting-css$' > "${hl_tpl}"
  pandoc "${sample_md}" --template="${hl_tpl}" -t html -o "${hl_default}"
  python3 - "${hl_default}" "${HL_CSS_KINDLE}" <<'PY'
import sys
from pathlib import Path

src, dst = Path(sys.argv[1]), Path(sys.argv[2])
old = "pre > code.sourceCode > span { display: inline-block; line-height: 1.25; }"
new = "pre > code.sourceCode > span { display: inline; line-height: 1.25; }"
text = src.read_text(encoding="utf-8")
if old not in text:
    raise SystemExit(f"expected skylighting rule not found in {src}")
dst.write_text(text.replace(old, new), encoding="utf-8")
print(f"Prepared Kindle-safe highlighting CSS: {dst}")
PY
}

prepare_kindle_highlighting_css

(
  cd "${LANG_DIR}"
  pandoc "${inputs[@]}" \
    -t epub3 \
    -F pandoc-crossref \
    -o "../${OUTPUT#${ROOT_DIR}/}" \
    -M "crossrefYaml=crossref.yaml" \
    --metadata-file="config-epub.yaml" \
    --epub-cover-image="image/Cover/電子版表紙_300dpi_2480x3508.png" \
    --css="../epub.css" \
    --resource-path="${RESOURCE_PATH}" \
    -V highlighting-css="$(cat "${HL_CSS_KINDLE}")"
)

echo "Language: ${LANG}"
echo "Output: ${OUTPUT}"
echo "Inputs (${CHAPTER_LIST}; plus preface.md):"
printf 'preface.md\n'
nl -ba "${CHAPTER_LIST}"
ls -lh "${OUTPUT}"
