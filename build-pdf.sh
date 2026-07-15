#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LANG="${1:-ja}"
LANG_DIR="${ROOT_DIR}/${LANG}"
OUT_DIR="${ROOT_DIR}/tmp"
OUTPUT="${OUT_DIR}/cloudnativetext_${LANG}.pdf"
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

if ! command -v pandoc >/dev/null 2>&1 || ! command -v lualatex >/dev/null 2>&1; then
  exec "${ROOT_DIR}/scripts/with-build-image.sh" "./build-pdf.sh" "${LANG}"
fi

if [[ ! -d "${LANG_DIR}" ]]; then
  echo "language directory not found: ${LANG_DIR}" >&2
  exit 1
fi

if [[ ! -f "${ROOT_DIR}/template.tex" || ! -f "${ROOT_DIR}/config-common-pdf.yaml" || ! -f "${LANG_DIR}/config-pdf.yaml" ]]; then
  echo "missing template or config under ${ROOT_DIR} / ${LANG_DIR}" >&2
  exit 1
fi

COVER_IMAGE="${LANG_DIR}/image/Cover/電子版表紙_300dpi_2480x3508.png"
if [[ ! -f "${COVER_IMAGE}" ]]; then
  echo "missing cover image: ${COVER_IMAGE}" >&2
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

if [[ ! -f "${LANG_DIR}/preface.md" ]]; then
  echo "missing ${LANG_DIR}/preface.md" >&2
  exit 1
fi

# 原稿パスは言語ディレクトリ基準（main ブランチと同じ ../08_img 等の相対参照を維持）
chapters=()
: > "${CHAPTER_LIST}"
for part in "${PART_DIRS[@]}"; do
  while IFS= read -r -d '' f; do
    rel="${f#${LANG_DIR}/}"
    chapters+=("${rel}")
    printf '%s\n' "${rel}" >> "${CHAPTER_LIST}"
  done < <(find "${LANG_DIR}/${part}" -maxdepth 1 -type f -name '*.md' -print0 | LC_ALL=C sort -z)
done

if ((${#chapters[@]} == 0)); then
  echo "no manuscript markdown files found under ${LANG_DIR}" >&2
  exit 1
fi

mapfile -t chapters < "${CHAPTER_LIST}"

(
  cd "${LANG_DIR}"
  pandoc preface.md -o "../tmp/preface-${LANG}.tex" --resource-path="${RESOURCE_PATH}"
  printf '%s\n' '\captionsetup[figure]{labelformat=empty,labelsep=none}' >> "../tmp/preface-${LANG}.tex"
  # 電子版 = 表紙画像あり（template.tex の wallpaper）。製本用に表紙なしが必要なら
  # -M no-cover=true を付けた別出力を追加する（server-text の guide_no_cover.pdf 相当）。
  printf '%s\0' "${chapters[@]}" | xargs -0 pandoc \
    -d "../config-common-pdf.yaml" \
    -d "config-pdf.yaml" \
    --template "../template.tex" \
    --resource-path="${RESOURCE_PATH}" \
    -B "../tmp/preface-${LANG}.tex" \
    -o "../tmp/cloudnativetext_${LANG}.pdf"
)

echo "Language: ${LANG}"
echo "Output: ${OUTPUT}"
echo "Chapters (${CHAPTER_LIST}):"
nl -ba "${CHAPTER_LIST}"
ls -lh "${OUTPUT}"
