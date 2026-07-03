# shellcheck shell=bash
# Resolve docker vs direct for build-pdf.sh / build-epub.sh.
#
# - Local host (no marker): default docker → script re-invokes itself in the image.
# - Inside cloudnative-text Docker image (CLOUDNATIVE_TEXT_BUILD=1): default direct.
# - Explicit PDF_BUILD_MODE / EPUB_BUILD_MODE always wins (escape hatch).
resolve_build_mode() {
  local explicit="${1:-}"
  if [[ -n "$explicit" ]]; then
    printf '%s\n' "$explicit"
  elif [[ "${CLOUDNATIVE_TEXT_BUILD:-}" == 1 ]]; then
    printf '%s\n' direct
  else
    printf '%s\n' docker
  fi
}
