# Aliases
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
