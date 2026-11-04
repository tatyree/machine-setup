# machine-setup

Rebuilds my Mac setup on another Mac.

## New machine

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tatyree/machine-setup/master/install.sh)"
```

`install.sh` installs the Xcode Command Line Tools if needed, clones this repo
to `~/machine-setup` (or pulls if it is already there), and runs
`bootstrap.sh` with any arguments you pass. The manual equivalent:

```sh
xcode-select --install          # wait for it to finish
git clone https://github.com/tatyree/machine-setup.git ~/machine-setup
~/machine-setup/bootstrap.sh
```

`bootstrap.sh` is safe to re-run. It installs everything in `Brewfile`,
applies the dotfiles with chezmoi, sets up Rust, asdf, and Vim/Neovim plugins,
clones `projects.txt`, starts Homebrew services and applies `macos.sh`.
It pauses for the App Store sign-in and for 1Password, then prints warnings
and the remaining manual steps.

On the first run, any existing file chezmoi is about to replace (`~/.zshrc`,
`~/.gitconfig`, the nvim config, and so on) is copied to
`<file>.pre-machine-setup` first. On later runs chezmoi asks before replacing
a file you have edited since it last wrote it.

Options: `--skip-projects`, `--skip-macos`, `--skip-mas`.

Mac App Store apps install last, one at a time with progress, after the
App Store sign-in (iCloud can stay off). Xcode alone is a long download.

## 1Password

Install and sign in to the 1Password app, then in Settings > Developer turn on
**Use the SSH agent** and **Integrate with 1Password CLI**. SSH keys stay in
1Password; `~/.ssh/config` points at its agent.

## Layout

| Path | What |
|---|---|
| `install.sh` | curl entry point: CLT, clone, then `bootstrap.sh` |
| `Brewfile` | Taps, formulae, casks, App Store apps, global npm packages |
| `home/` | chezmoi source (`.chezmoiroot` points here) |
| `home/.chezmoiexternal.toml` | oh-my-zsh, wez-tmux, vim-plug and Cloudflare's agent skills, fetched from upstream |
| `asdf/plugins` | asdf plugins and their git URLs |
| `projects.txt` | Repos to clone |
| `macos.sh` | `defaults write` settings |
| `INVENTORY.md` | What was found and what was left out |

## Machine-specific additions

These optional drop-ins are picked up when present and ignored otherwise, so
another setup layered on top can extend this one without editing it:

| Drop-in | Effect |
|---|---|
| `~/.zshrc.d/*.zsh` | Sourced by `.zshrc` |
| `~/.ssh/config.d/*` | Included at the top of `~/.ssh/config` |
| `~/.config/wezterm/extra.lua` | A `function(config)` WezTerm calls before returning its config |
| `~/.config/machine-setup/extra/CLAUDE.md` | Appended to `~/.claude/CLAUDE.md` on `chezmoi apply` |
| `~/.config/machine-setup/extra/gitignore_global` | Appended to `~/.gitignore_global` |
| `~/.config/machine-setup/extra/claude-automode-environment.json` | Used as `autoMode.environment` in `~/.claude/settings.json` |

## Day to day

- Change a dotfile: `chezmoi edit ~/.zshrc`, or edit in place and
  `chezmoi re-add`. Then commit here.
- New app: add it to `Brewfile`, or `brew bundle dump --force` and review the
  diff.
