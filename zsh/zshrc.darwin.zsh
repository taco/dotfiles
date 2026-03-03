plugins=(
  git
  history-substring-search
  brew
  macos
  copypath
  extract
)

eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="/Users/travisj/.amp/bin:$PATH"

export VISUAL="cursor -w"
export EDITOR="cursor -w"
