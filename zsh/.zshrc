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

# OS-specific config (plugins, brew shellenv, EDITOR, etc.)
OS="$(uname -s)"
if [ "$OS" = "Darwin" ]; then
  source "$HOME/.zshrc.darwin"
else
  source "$HOME/.zshrc.linux"
fi

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"

# pnpm tab completion (must be after fnm which provides pnpm)
eval "$(pnpm completion zsh)"

# Aliases and functions
source "$HOME/.aliases.zsh"

export PATH="$HOME/.local/bin:$PATH"

# zoxide (smart cd replacement — use `z` to jump to directories)
eval "$(zoxide init zsh)"

# Fish-like plugins (must be after oh-my-zsh)
if [ "$OS" = "Darwin" ]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || true
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || true
fi
