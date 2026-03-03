plugins=(
  git
  history-substring-search
  extract
)

# Linuxbrew (if installed)
if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

export VISUAL="vim"
export EDITOR="vim"
