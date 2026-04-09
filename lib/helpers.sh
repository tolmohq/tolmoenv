#!/usr/bin/env bash

TOLMOENV_ROOT="${TOLMOENV_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
TOLMOENV_REPO="${TOLMOENV_REPO:-tolmohq/tolmo}"

log_info() {
  echo "[info] $*"
}

log_error() {
  echo "[error] $*" >&2
  [ -n "${2:-}" ] && echo "$2" >&2
  exit 1
}

log_debug() {
  [ "${TOLMOENV_DEBUG:-0}" != "0" ] && echo "[debug] $*" >&2
  return 0
}

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "darwin" ;;
    Linux)  echo "linux" ;;
    *)      log_error "Unsupported OS: $(uname -s)" ;;
  esac
}

detect_arch() {
  local arch="${TOLMOENV_ARCH:-$(uname -m)}"
  case "$arch" in
    x86_64|amd64)  echo "amd64" ;;
    aarch64|arm64)  echo "arm64" ;;
    *)              log_error "Unsupported architecture: $arch" ;;
  esac
}

verify_checksum() {
  local file="$1"
  local expected="$2"

  if [ -z "$expected" ]; then
    log_debug "No checksum to verify"
    return 0
  fi

  local actual
  if command -v sha256sum >/dev/null 2>&1; then
    actual="$(sha256sum "$file" | cut -d' ' -f1)"
  elif command -v shasum >/dev/null 2>&1; then
    actual="$(shasum -a 256 "$file" | cut -d' ' -f1)"
  else
    log_info "Warning: no sha256sum or shasum available, skipping verification"
    return 0
  fi

  if [ "$actual" != "$expected" ]; then
    log_error "Checksum verification failed (expected: $expected, actual: $actual)"
  fi

  log_debug "Checksum verified: $actual"
}

version_file() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    if [ -f "$dir/.tolmo-version" ]; then
      echo "$dir/.tolmo-version"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  echo "$TOLMOENV_ROOT/version"
}

current_version() {
  local vfile
  vfile="$(version_file)"
  if [ -f "$vfile" ]; then
    cat "$vfile" | tr -d '[:space:]'
  fi
}
