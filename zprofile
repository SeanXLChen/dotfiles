# Homebrew — set up brew's env vars (PATH, MANPATH, etc.) for Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

# Sublime Text CLI (`subl` command) on PATH
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

# Python — via Homebrew python@3.14 (see Brewfile), already on PATH from brew shellenv above
