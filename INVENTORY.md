# Inventory

Taken from the Mac Studio (macOS 15.5, arm64) on 2026-11-01.

## Packages (`Brewfile`)

| Type | Count |
|---|---|
| tap | 5 |
| brew | 97 (includes `chezmoi`, `mas`, `git-lfs`, `postgresql@16`) |
| cask | 46 (includes `1password`, `1password-cli`) |
| mas | 17 |
| npm | 6 |

Deliberately left out: casks blender, chatgpt, commandpost, gimp,
intellij-idea, iterm2, lastpass, league-of-legends, miro, parallels,
redis-stack-server, visual-studio-code, vlc, windsurf; formulae mpv (the cask
is used), postgresql@14, borgbackup, python@3.11 (asdf manages Python).

Taps dropped: `homebrew/services` (deprecated; `brew services` is built into
Homebrew now) and `gabotechs/taps` (fails to tap), which also drops its
`musicgpt` formula.

### Apps with no cask (manual install)

- Blackmagic Proxy Generator, Blackmagic RAW
- KeepStreams
- Trim Enabler
- Corsair iCUE
- Autodesk
- uTorrent Web

## Language runtimes

- asdf 0.16 from Homebrew. Plugins and URLs in `asdf/plugins`; global versions
  in `home/dot_tool-versions` (the live file had a typo in the java version,
  `adoptopnjdk`, fixed here).
- Rust via rustup, installed by bootstrap.

## Dotfiles (`home/`)

zsh (`.zshrc`, `.zsh_aliases`, `.zsh_functions`, `.zshenv`, `.zprofile`),
`.gitconfig`, `.gitignore_global`, `.tmux.conf`, `.vimrc`, `.ackrc`,
`.borg-exclude` (still used by `rsy`), `.tool-versions`, `~/.ssh/config`, and
`~/.config/{starship.toml,nvim,wezterm,mpv,micro,gh,git}`.

`~/.claude`: `CLAUDE.md` and `settings.json`. Cloudflare's skills are linked
from a checkout of github.com/cloudflare/skills (`sandbox-sdk` is now
`sandbox-stable` upstream).

`caffeinate` was stripped from `rsy` and `quick_backup`. The Windsurf `PATH`
line was dropped.

Fetched from upstream by chezmoi: oh-my-zsh, wez-tmux, vim-plug, cloudflare/skills.

## SSH

`~/.ssh/config` uses the 1Password SSH agent when 1Password is signed in, and
falls back to the old Keychain setup otherwise. Keys live in 1Password, not in
this repo.

## macOS settings (`macos.sh`)

Dark mode, double-click to minimise, Dock autohide and magnification (62/54),
no Spaces reordering, three hot corners cleared, Finder path and status bars,
list view, new windows open All Files, external drives on the desktop, clock
with AM/PM and weekday, no click-to-show-desktop, tap to click off.
