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

alias g='git'

# Kill processes listening on a given port
# Usage: killport <port> [filter]
killport() {
  local port=$1
  local filter=$2
  if [[ -z "$port" ]]; then
    echo "Usage: killport <port> [filter]"
    return 1
  fi

  if [[ -n "$filter" ]]; then
    local pids=$(lsof -i tcp:$port | awk -v f="$filter" 'NR>1 && tolower($1) ~ tolower(f) {print $2}' | sort -u)
  else
    local pids=$(lsof -ti tcp:$port)
  fi

  if [[ -z "$pids" ]]; then
    echo "No ${filter:+$filter }processes on port $port"
    return 0
  fi

  echo "Killing${filter:+ $filter} PIDs: $pids"
  echo $pids | xargs kill 2>/dev/null || echo $pids | xargs kill -9 2>/dev/null
}

wakepc() {
  wakeonlan 74:56:3C:45:00:C9
}

ssh-wsl() {
  ssh taco@wsl -p 2222
}

ssh-win() {
  ssh raptor\\tvjoh@win -p 22
}

export PATH="/Users/travisj/.amp/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export VISUAL="cursor -w"
export EDITOR="cursor -w"

# zoxide (smart cd replacement — use `z` to jump to directories)
eval "$(zoxide init zsh)"

# Fish-like plugins (must be after oh-my-zsh)
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
