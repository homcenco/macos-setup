#!/bin/bash
set -u

# Global variables
ZPROFILE_FILE="$HOME/.zprofile"
ZPROFILE_LINK="https://raw.githubusercontent.com/homcenco/macos-setup/main/zprofile/.zprofile"

# Abort function
abort() {
  printf "%s\n" "$@"
  exit 1
}

# Setup zprofile
function setup_zprofile() {
  # Check if Bash exists
  [ -z "${BASH_VERSION:-}" ] && abort "Bash is required to interpret this script."
  # Delete .zprofile if exists
  [ -f "$ZPROFILE_FILE" ] && rm -f "$ZPROFILE_FILE"
  # Copy new `.zprofile` file from repository
  curl -o "$ZPROFILE_FILE" "$ZPROFILE_LINK"
}

setup_zprofile
