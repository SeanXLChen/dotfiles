# dotfiles
Dotfiles for macOS dev setup — shell + git + AI tooling configs

## What's here

- `zshenv`, `zshrc`, `zprofile`, `gitconfig`, `config/git/ignore`, `ssh-config` — tracked config, symlinked into `$HOME`
- `claude/CLAUDE.md`, `claude/settings.json` — global Claude Code config, symlinked into `~/.claude/`
- `Brewfile` — CLI tools the aliases/functions in `zshrc` depend on (eza, bat, lazygit, zoxide, yazi, tlrc, zsh-syntax-highlighting, zsh-autosuggestions, uv, python@3.14, 1password-cli)
- `install.sh` — symlinks each file into place (backing up any existing real file to `*.bak`), then runs `brew bundle` to install missing tools

## Install

```sh
git clone https://github.com/SeanXLChen/dotfiles.git ~/GitHub/dotfiles
~/GitHub/dotfiles/install.sh
```

Then, before this machine can push/pull over SSH or use signing:
- Create `~/.gitconfig.local` — see Git identity below.
- Set up the 1Password SSH agent — see SSH below. `install.sh` only symlinks the config; it does **not** enable the agent, so `git@github.com` will fail to authenticate until you've done that manually.

Then clone `second-brain` to `~/second-brain/` (Obsidian vault the Claude config references):

```sh
git clone git@github.com:SeanXLChen/second-brain.git ~/second-brain
```

## Claude Code

`claude/CLAUDE.md` + `claude/settings.json` are symlinked into `~/.claude/` by `install.sh` — global instructions (second-brain conventions, Notion workspace map) plus permissions, hooks, and the plugin/marketplace list (so `plan-review-consensus`, `ponytail`, etc. come along automatically once the marketplace is reachable). MCP server configs (`mcp.json`) are **not** committed — they hold API tokens; reconfigure manually per machine.

## Git identity

`gitconfig` has no `[user]` section — it `include`s `~/.gitconfig.local` instead, since name/email vary per machine (e.g. work vs. personal) and shouldn't be baked into a shared, public repo. On a new machine:

```sh
cat > ~/.gitconfig.local << 'EOF'
[user]
	name = Your Name
	email = your@email.com
EOF
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

## SSH

`ssh-config` (symlinked to `~/.ssh/config`) points every host at the 1Password SSH agent:

```
Host *
	IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
```

The actual SSH key lives only in 1Password (item "id_ed25519 (Personal - shared across machines)", Private vault) — it's never on disk as a plaintext file on any machine.

**Required on every machine — `install.sh` cannot do this part for you:**
1. Install the 1Password app on this machine and sign in to the same account.
2. In the app: Settings → Developer → enable "Use the SSH agent".

Only after both of those are done does `ssh-config` (symlinked by `install.sh`, or paste the snippet above manually) actually work — the socket it points to doesn't exist until the agent is enabled. Verify with:

```sh
ssh -T git@github.com   # should authenticate with no local key file present
```

If this fails with "Could not open a connection to your authentication agent" or similar, the 1Password SSH agent isn't enabled yet — go do step 2.

This key is shared across personal machines only — a work machine should get its own separate key/item, not this one.
