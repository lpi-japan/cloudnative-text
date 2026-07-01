#!/bin/bash
# pandoc/extra に無い TeX パッケージを tlmgr で追加する。
# 固定 tlnet → update --self + 固定 tlnet → live tlnet の順で試す。
set -euo pipefail

readonly PACKAGES=(collection-langjapanese tocloft wallpaper eso-pic)
readonly PINNED_REPOS=(
  "https://latex.us/systems/texlive/tlnet"
  "https://mirrors.mit.edu/CTAN/systems/texlive/tlnet"
)
readonly LIVE_REPO="https://mirror.ctan.org/systems/texlive/tlnet"

pkg_installed() {
  tlmgr info --only-installed "$1" 2>/dev/null | grep -q 'installed:   Yes'
}

all_installed() {
  local pkg
  for pkg in "${PACKAGES[@]}"; do
    pkg_installed "$pkg" || return 1
  done
}

try_install() {
  local repo="$1"
  local update_self="$2"
  shift 2
  echo "tlmgr: repository=${repo} update_self=${update_self} packages=$*"
  tlmgr option repository "${repo}"
  if [[ "${update_self}" == "1" ]]; then
    tlmgr update --self
  fi
  tlmgr install "$@" || true
  all_installed
}

missing=()
for pkg in "${PACKAGES[@]}"; do
  pkg_installed "$pkg" || missing+=("$pkg")
done

if ((${#missing[@]} == 0)); then
  echo "tlmgr: required packages already installed"
  exit 0
fi

echo "tlmgr: installing ${missing[*]}"

for repo in "${PINNED_REPOS[@]}"; do
  try_install "${repo}" 0 "${missing[@]}" && exit 0
done

for repo in "${PINNED_REPOS[@]}"; do
  try_install "${repo}" 1 "${missing[@]}" && exit 0
done

try_install "${LIVE_REPO}" 1 "${missing[@]}" && exit 0

echo "tlmgr: install failed for: ${missing[*]}" >&2
exit 1
