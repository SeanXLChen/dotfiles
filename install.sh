#!/usr/bin/env bash
set -euo pipefail

# Resolve repo root regardless of where this script is invoked from.
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Symlink $DOTFILES/$1 -> $HOME/$2, backing up any pre-existing real file
# (not already a symlink) to *.bak so nothing gets silently overwritten.
link() {
  local src="$DOTFILES/$1" dst="$HOME/$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "backing up existing $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sf "$src" "$dst"
  echo "linked $dst -> $src"
}

link zshenv .zshenv
link zshrc .zshrc
link zprofile .zprofile
link gitconfig .gitconfig
link config/git/ignore .config/git/ignore
link ssh-config .ssh/config

# Claude Code global config
link claude/CLAUDE.md .claude/CLAUDE.md
link claude/settings.json .claude/settings.json

# Install CLI tools the aliases/functions in zshrc depend on (eza, bat, etc.)
if command -v brew >/dev/null 2>&1; then
  brew bundle --file="$DOTFILES/Brewfile" || echo "brew bundle failed — rerun manually: brew bundle --file=$DOTFILES/Brewfile"
else
  echo "homebrew not found — skipping Brewfile install, run it manually later"
fi

# Secrets (~/.zshrc.local) are intentionally NOT managed here — see README
# for pulling them from 1Password onto a new machine.
echo "done. put machine-local secrets in ~/.zshrc.local (sourced automatically, not tracked)."
