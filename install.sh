#!/usr/bin/env bash
set -euo pipefail

# Cortex CLI (cx) installer
# Usage: curl -sSL https://raw.githubusercontent.com/jsvitolo/cortex-releases/main/install.sh | bash

REPO="jsvitolo/cortex-releases"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
BINARY="cx"

# Detect OS and architecture
detect_platform() {
  local os arch

  os="$(uname -s | tr '[:upper:]' '[:lower:]')"
  arch="$(uname -m)"

  case "$os" in
    linux)  os="linux" ;;
    darwin) os="darwin" ;;
    *)
      echo "Error: Unsupported OS: $os" >&2
      exit 1
      ;;
  esac

  case "$arch" in
    x86_64|amd64)  arch="amd64" ;;
    arm64|aarch64) arch="arm64" ;;
    *)
      echo "Error: Unsupported architecture: $arch" >&2
      exit 1
      ;;
  esac

  echo "${os}_${arch}"
}

# Get the latest release tag from GitHub
get_latest_version() {
  local version
  version="$(curl -sSf "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')"

  if [ -z "$version" ]; then
    echo "Error: Could not determine latest version" >&2
    exit 1
  fi

  echo "$version"
}

main() {
  local platform version version_no_v archive_name url tmp_dir

  echo "Installing Cortex CLI (cx)..."
  echo ""

  platform="$(detect_platform)"
  echo "  Platform: ${platform}"

  if [ -n "${VERSION:-}" ]; then
    version="$VERSION"
  else
    version="$(get_latest_version)"
  fi
  echo "  Version:  ${version}"

  version_no_v="${version#v}"
  archive_name="cx_${version_no_v}_${platform}.tar.gz"
  url="https://github.com/${REPO}/releases/download/${version}/${archive_name}"

  echo "  Archive:  ${archive_name}"
  echo ""

  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' EXIT

  echo "Downloading ${url}..."
  curl -sSfL -o "${tmp_dir}/${archive_name}" "$url"

  echo "Extracting..."
  tar xzf "${tmp_dir}/${archive_name}" -C "$tmp_dir"

  echo "Installing to ${INSTALL_DIR}/${BINARY}..."
  if [ -w "$INSTALL_DIR" ]; then
    mv "${tmp_dir}/${BINARY}" "${INSTALL_DIR}/${BINARY}"
  else
    sudo mv "${tmp_dir}/${BINARY}" "${INSTALL_DIR}/${BINARY}"
  fi
  chmod +x "${INSTALL_DIR}/${BINARY}"

  echo ""
  echo "Cortex CLI (cx) ${version} installed successfully!"
  echo ""
  echo "Run 'cx --help' to get started."
}

main
