# Homebrew — set up brew's env vars (PATH, MANPATH, etc.) for Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

# Sublime Text CLI (`subl` command) on PATH
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

# Prefer Python 3.12 framework build over system/other Pythons
PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"
export PATH
