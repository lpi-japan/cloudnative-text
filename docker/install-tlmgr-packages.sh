#!/bin/bash
# pandoc/extra に無い TeX パッケージを tlmgr で追加する。
# 固定 tlnet で install → update --self（1 回）→ 固定 tlnet で install → live tlnet
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
  shift
  echo "tlmgr: repository=${repo} packages=$*"
  tlmgr option repository "${repo}"
  tlmgr install "$@" || true
  all_installed
}

# update --self は tlmgr クライアント自体の更新（リポジトリ設定もグローバル）。
# どのミラーから取るかだけ試し、成功したら 1 回で終わり。
update_tlmgr_self() {
  local repo
  for repo in "${PINNED_REPOS[@]}" "${LIVE_REPO}"; do
    echo "tlmgr: update --self via ${repo}"
    tlmgr option repository "${repo}"
    if tlmgr update --self; then
      echo "tlmgr: update --self ok"
      return 0
    fi
  done
  echo "tlmgr: update --self failed on all mirrors" >&2
  return 1
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
  try_install "${repo}" "${missing[@]}" && exit 0
done

update_tlmgr_self || true

for repo in "${PINNED_REPOS[@]}"; do
  try_install "${repo}" "${missing[@]}" && exit 0
done

try_install "${LIVE_REPO}" "${missing[@]}" && exit 0

echo "tlmgr: install failed for: ${missing[*]}" >&2
exit 1
