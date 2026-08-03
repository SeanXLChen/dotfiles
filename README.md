# dotfiles
Dotfiles for macOS dev setup — shell + git + AI tooling configs

## What's here

- `zshrc`, `zprofile`, `gitconfig`, `config/git/ignore` — tracked config, symlinked into `$HOME`
- `Brewfile` — CLI tools the aliases/functions in `zshrc` depend on (eza, bat, lazygit, zoxide, yazi, tlrc, zsh-syntax-highlighting)
- `install.sh` — symlinks each file into place (backing up any existing real file to `*.bak`), then runs `brew bundle` to install missing tools

## Install

```sh
git clone https://github.com/SeanXLChen/dotfiles.git ~/GitHub/dotfiles
~/GitHub/dotfiles/install.sh
```

## Secrets

`zshrc` sources `~/.zshrc.local` if present — that file is **not** tracked here (see `.gitignore`) since it holds real API keys / passwords.

On a new machine, before (or after) running `install.sh`:

1. Store `.zshrc.local`'s contents as a document/secure note in 1Password (e.g. item "zshrc.local").
2. Pull it down to `~/.zshrc.local` — either paste manually, or via CLI:
   ```sh
   op document get "zshrc.local" --out-file ~/.zshrc.local
   chmod 600 ~/.zshrc.local
   ```
3. Open a new shell — secrets load automatically.

Keep the 1Password copy updated whenever you rotate a key locally.
