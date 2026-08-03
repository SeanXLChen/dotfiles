# dotfiles
Dotfiles for macOS dev setup — shell + git + AI tooling configs

## What's here

- `zshrc`, `zprofile`, `gitconfig`, `config/git/ignore` — tracked config, symlinked into `$HOME`
- `Brewfile` — CLI tools the aliases/functions in `zshrc` depend on (eza, bat, lazygit, zoxide, yazi, tlrc, zsh-syntax-highlighting, zsh-autosuggestions, 1password-cli)
- `install.sh` — symlinks each file into place (backing up any existing real file to `*.bak`), then runs `brew bundle` to install missing tools

## Install

```sh
git clone https://github.com/SeanXLChen/dotfiles.git ~/GitHub/dotfiles
~/GitHub/dotfiles/install.sh
```

## Secrets

`zshrc` sources `~/.zshrc.local` if present — that file is **not** tracked here (see `.gitignore`) since it holds real API keys / passwords.

There's a single 1Password document, `zshrc.local` (Private vault), that's meant to hold the union of every machine's secrets — not a per-machine copy. So it's always **pull, merge, push**, never overwrite:

**Adding/changing a secret on a machine:**
1. Pull the current copy down (see below) and open it next to your local `~/.zshrc.local`.
2. Merge by hand — add your new/changed line(s) into the pulled copy, keeping whatever other machines already added.
3. Save the merged result back to 1Password:
   - Have `op` CLI + signed in: `op document edit "zshrc.local" <merged-file>`
   - No CLI: paste the merged content into the `zshrc.local` document in the 1Password app.

**Setting up on a (new or existing) machine:**
1. Pull it down — `op document get "zshrc.local" --out-file ~/.zshrc.local` (or copy-paste from the app if no CLI).
2. `chmod 600 ~/.zshrc.local`
3. Open a new shell — secrets load automatically.
