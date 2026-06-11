#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OS_HELPER="$ROOT_DIR/scripts/os_detect.sh"

if [ ! -f "$OS_HELPER" ]; then
  echo "Missing os_detect helper: $OS_HELPER"
  exit 2
fi

# shellcheck source=/dev/null
. "$OS_HELPER"

echo "Detected OS: $OS"
echo "Default install dir: $DEFAULT_INSTALL_DIR"
echo "Default config dir: $DEFAULT_CONFIG_DIR"

if [ -z "$OS" ] || [ -z "$DEFAULT_INSTALL_DIR" ] || [ -z "$DEFAULT_CONFIG_DIR" ]; then
  echo "OS detection failed"
  exit 1
fi

echo "OS detection test passed"
exit 0
