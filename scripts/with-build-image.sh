#!/usr/bin/env bash
# Host にビルド用ツールチェーンが無いとき、イメージ内で COMMAND を再実行する。
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE="${TEXT_IMAGE:-ghcr.io/lpi-japan/cloudnative-text:local}"

if ! docker image inspect "${IMAGE}" >/dev/null 2>&1; then
  echo "Building image: ${IMAGE}" >&2
  docker build -f "${ROOT_DIR}/docker/Dockerfile" -t "${IMAGE}" "${ROOT_DIR}/docker"
fi

exec docker run --rm -i \
  -e LC_ALL=C.UTF-8 \
  -v "${ROOT_DIR}:/data" \
  -w /data \
  --entrypoint /bin/bash \
  "${IMAGE}" -lc "$*"
