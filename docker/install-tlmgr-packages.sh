#!/bin/bash
# TeX Live 追加パッケージを、ベースイメージ内 tlmgr と互換の固定ミラーから入れる。
# live CTAN (mirror.ctan.org 経由) は tlnet が進み、古い tlmgr クライアントでは
#   install 前に update --self を要求する → ビルドが不安定になる。
# update --self も CTAN 側の状態次第で失敗するため、ここでは使わない。
set -euo pipefail

readonly PACKAGES=(collection-langjapanese tocloft wallpaper eso-pic)

# ベース digest 更新時は、必要なら TLMGR_REPOS の順序・URL を見直す。
readonly TLMGR_REPOS=(
  "https://latex.us/systems/texlive/tlnet"
)

missing=()
for pkg in "${PACKAGES[@]}"; do
  if ! tlmgr info --only-installed "$pkg" 2>/dev/null | grep -q 'installed:   Yes'; then
    missing+=("$pkg")
  fi
done

if ((${#missing[@]} == 0)); then
  echo "tlmgr: required packages already installed; skipping"
  exit 0
fi

echo "tlmgr: installing ${missing[*]}"

for repo in "${TLMGR_REPOS[@]}"; do
  echo "tlmgr: trying repository ${repo}"
  if tlmgr option repository "${repo}" && tlmgr install "${missing[@]}"; then
    echo "tlmgr: installed from ${repo}"
    exit 0
  fi
  echo "tlmgr: failed with ${repo}" >&2
done

echo "tlmgr: all pinned repositories failed; not falling back to update --self" >&2
exit 1
