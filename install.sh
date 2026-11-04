#!/usr/bin/env bash
# One-line installer for a fresh Mac:
#
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/tatyree/machine-setup/master/install.sh)"
#
# Installs the Xcode Command Line Tools if needed, clones (or updates) this repo
# into ~/machine-setup, then runs bootstrap.sh with the same arguments.
# Everything is inside main() so a partial download runs nothing.
set -euo pipefail

main() {
  local repo_url="https://github.com/tatyree/machine-setup.git"
  local dest="${MACHINE_SETUP_DIR:-$HOME/machine-setup}"

  if [ "$(uname -s)" != Darwin ]; then
    echo "This installer is for macOS." >&2
    exit 1
  fi

  # git on a fresh Mac is a stub until the Command Line Tools are installed.
  if ! xcode-select -p >/dev/null 2>&1; then
    echo "==> Installing Xcode Command Line Tools (finish the dialog that opens)"
    xcode-select --install >/dev/null 2>&1 || true
    until xcode-select -p >/dev/null 2>&1; do sleep 10; done
  fi

  if [ -d "$dest/.git" ]; then
    echo "==> Updating $dest"
    git -C "$dest" pull --ff-only
  elif [ -e "$dest" ]; then
    echo "$dest exists and is not a git checkout; move it aside and re-run." >&2
    exit 1
  else
    echo "==> Cloning into $dest"
    git clone "$repo_url" "$dest"
  fi

  # Reattach the terminal so bootstrap's prompts work even when piped from curl.
  if [ -r /dev/tty ]; then
    exec "$dest/bootstrap.sh" "$@" </dev/tty
  else
    exec "$dest/bootstrap.sh" "$@"
  fi
}

main "$@"
