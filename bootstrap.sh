#!/usr/bin/env bash
# Set up a new Mac from this repo. Safe to re-run: every step skips work that
# is already done. See README.md for the one-line install.
#
# Options:
#   --skip-projects   don't clone the repos in projects.txt
#   --skip-macos      don't apply macos.sh
#   --skip-mas        don't install the Mac App Store apps (the mas lines in Brewfile)
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKIP_PROJECTS=0
SKIP_MACOS=0
SKIP_MAS=0
while [ $# -gt 0 ]; do
  case "$1" in
    --skip-projects) SKIP_PROJECTS=1 ;;
    --skip-macos) SKIP_MACOS=1 ;;
    --skip-mas) SKIP_MAS=1 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

WARNINGS=()
step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m!! %s\033[0m\n' "$*"; WARNINGS+=("$*"); }
pause() { if [ -t 0 ]; then read -r -p "$* Press Enter to continue. " _; fi; }

# 1. Xcode Command Line Tools
step "Xcode Command Line Tools"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install || true
  until xcode-select -p >/dev/null 2>&1; do sleep 10; done
fi

# 2. Homebrew
step "Homebrew"
if ! command -v brew >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ]; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# 3. Packages. App Store apps are installed separately at the end (step 12),
#    because big ones like Xcode download for a long time with no output here.
step "Brewfile (without App Store apps)"
grep -v '^mas ' "$REPO_DIR/Brewfile" | brew bundle --file=- --no-upgrade \
  || warn "brew bundle had failures; re-run 'brew bundle --file=$REPO_DIR/Brewfile' to see them"

# 4. 1Password (SSH agent)
step "1Password"
if ! op vault list >/dev/null 2>&1; then
  pause "Open 1Password and sign in. In Settings > Developer, turn on 'Use the SSH agent' and 'Integrate with 1Password CLI'."
fi
if op vault list >/dev/null 2>&1; then
  ONEPASSWORD=true
else
  ONEPASSWORD=false
  warn "1Password CLI not signed in: the SSH agent config was skipped. Sign in and re-run bootstrap.sh"
fi

# 5. Dotfiles
step "Dotfiles (chezmoi)"
mkdir -p "$HOME/.config/chezmoi"
cat > "$HOME/.config/chezmoi/chezmoi.toml" <<EOF
sourceDir = "$REPO_DIR"

[data]
    onepassword = $ONEPASSWORD
EOF

# First run only (chezmoi has never applied here): copy every existing file
# chezmoi is about to replace to <file>.pre-machine-setup. Later runs rely on
# chezmoi's own prompt for files edited since it last wrote them.
if [ ! -e "$HOME/.config/chezmoi/chezmoistate.boltdb" ]; then
  ts="$(date +%Y%m%d-%H%M%S)"
  # Status lines are "XY path"; Y = M means apply would modify an existing target.
  while IFS= read -r line; do
    [ "${line:1:1}" = M ] || continue
    rel="${line:3}"
    target="$HOME/$rel"
    [ -e "$target" ] || [ -L "$target" ] || continue
    backup="$target.pre-machine-setup"
    [ -e "$backup" ] || [ -L "$backup" ] && backup="$backup.$ts"
    if cp -pPR "$target" "$backup"; then
      echo "  backed up ~/$rel -> ~/${backup#"$HOME"/}"
    else
      warn "Could not back up ~/$rel; chezmoi will still ask before replacing it"
    fi
  done < <(chezmoi status --include=files,symlinks 2>/dev/null || true)
fi
chezmoi apply

# 6. Rust (.zshenv sources ~/.cargo/env)
step "Rust"
if [ ! -x "$HOME/.cargo/bin/rustup" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

# 7. asdf plugins and global versions
step "asdf"
installed_plugins="$(asdf plugin list 2>/dev/null || true)"
while read -r name url; do
  case "$name" in ''|\#*) continue ;; esac
  grep -qx "$name" <<<"$installed_plugins" || asdf plugin add "$name" "$url"
done < "$REPO_DIR/asdf/plugins"
(cd "$HOME" && asdf install) || warn "asdf install had failures; run 'cd ~ && asdf install' to retry"

# 8. Editor plugins
step "Vim and Neovim plugins"
vim -es -u "$HOME/.vimrc" +PlugInstall +qall || warn "vim PlugInstall failed"
nvim --headless "+Lazy! restore" +qa || warn "nvim Lazy restore failed"

# 9. Project repos
if [ "$SKIP_PROJECTS" -eq 0 ]; then
  step "Project repos"
  while read -r path remote branch; do
    case "$path" in ''|\#*) continue ;; esac
    dest="$HOME/$path"
    [ -e "$dest" ] && continue
    mkdir -p "$(dirname "$dest")"
    git clone --branch "$branch" "$remote" "$dest" || warn "Could not clone $remote"
  done < "$REPO_DIR/projects.txt"
fi

# 10. Services
step "Homebrew services"
brew services start postgresql@16 || warn "postgresql@16 did not start"
brew services start nginx || warn "nginx did not start"

# 11. macOS settings
if [ "$SKIP_MACOS" -eq 0 ]; then
  step "macOS settings"
  "$REPO_DIR/macos.sh"
fi

# 12. Mac App Store apps, one at a time so progress is visible.
if [ "$SKIP_MAS" -eq 0 ]; then
  step "Mac App Store apps"
  pause "Sign in to the App Store app (Store > Sign In; iCloud can stay off)."
  installed_mas="$(mas list 2>/dev/null | awk '{print $1}')"
  while IFS= read -r line; do
    name="$(sed -E 's/^mas "([^"]+)".*/\1/' <<<"$line")"
    id="$(sed -E 's/.*id: *([0-9]+).*/\1/' <<<"$line")"
    if grep -qx "$id" <<<"$installed_mas"; then
      echo "  already installed: $name"
      continue
    fi
    echo "  installing $name ($id)..."
    mas install "$id" || warn "App Store install failed for $name: open it in the App Store and click Get once, then re-run with 'mas install $id'"
  done < <(grep '^mas ' "$REPO_DIR/Brewfile")
fi

step "Done"
if [ "${#WARNINGS[@]}" -gt 0 ]; then
  echo "Warnings:"
  printf '  - %s\n' "${WARNINGS[@]}"
fi
cat <<'EOF'

Still to do by hand:
  - Sign in: Chrome, Google Drive, Keybase, Slack, WhatsApp
  - gh auth login; gcloud auth login
  - Licences: Kaleidoscope
  - Apps with no cask: see INVENTORY.md, "Apps with no cask"
  - Privacy permissions: Full Disk Access, Screen Recording, Accessibility,
    Camera and Microphone for terminals, OBS, Zoom
EOF
