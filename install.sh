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
# CLAUDE.md is a plain symlink; settings.json is GENERATED (shared repo layer +
# untracked ~/.claude/settings.machine.json) because Claude Code writes into it
# and part of the machine layer is sensitive — see claude/build-settings.sh.
link claude/CLAUDE.md .claude/CLAUDE.md
"$DOTFILES/claude/build-settings.sh"

# Claude auto-memory lives in the private vault, not this public repo. Claude
# keys memory by launch dir, so link the one for ~/second-brain (launch there:
# trust in ~ is never persisted).
MEMORY_SRC="$HOME/second-brain/.claude-memory"
MEMORY_DST="$HOME/.claude/projects/$(printf '%s' "$HOME/second-brain" | sed 's/[^A-Za-z0-9]/-/g')/memory"
if [ -d "$MEMORY_SRC" ]; then
  mkdir -p "$(dirname "$MEMORY_DST")"
  if [ -e "$MEMORY_DST" ] && [ ! -L "$MEMORY_DST" ]; then
    echo "backing up existing $MEMORY_DST -> $MEMORY_DST.bak (merge it into $MEMORY_SRC by hand)"
    mv "$MEMORY_DST" "$MEMORY_DST.bak"
  fi
  ln -sfn "$MEMORY_SRC" "$MEMORY_DST"
  echo "linked $MEMORY_DST -> $MEMORY_SRC"
else
  echo "~/second-brain not cloned yet — skipping Claude memory link; rerun install.sh after cloning"
fi

# Install CLI tools the aliases/functions in zshrc depend on (eza, bat, etc.)
if command -v brew >/dev/null 2>&1; then
  brew bundle --file="$DOTFILES/Brewfile" || echo "brew bundle failed — rerun manually: brew bundle --file=$DOTFILES/Brewfile"
else
  echo "homebrew not found — skipping Brewfile install, run it manually later"
fi

# Secrets (~/.zshrc.local) are intentionally NOT managed here — see README
# for pulling them from 1Password onto a new machine.
echo "done. put machine-local secrets in ~/.zshrc.local (sourced automatically, not tracked)."
