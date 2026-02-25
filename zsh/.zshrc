export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

# History settings
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS

# Shell options
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS

plugins=(
  git
  history-substring-search
  brew
  macos
  copypath
  extract
)

source $ZSH/oh-my-zsh.sh

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"

# pnpm tab completion (must be after fnm which provides pnpm)
eval "$(pnpm completion zsh)"

# Aliases and functions
source "$HOME/.aliases.zsh"

export PATH="/Users/travisj/.amp/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export VISUAL="cursor -w"
export EDITOR="cursor -w"

# zoxide (smart cd replacement — use `z` to jump to directories)
eval "$(zoxide init zsh)"

# Fish-like plugins (must be after oh-my-zsh)
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
