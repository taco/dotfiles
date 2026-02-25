#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
FOLDER="${DIR##*/}"

# Colors (ANSI 24-bit true color)
C_FOLDER="\x1b[38;2;3;122;152m"   # #037a98
C_BRANCH="\x1b[38;2;188;5;188m"   # #bc05bc
C_NODE="\x1b[38;2;10;120;10m"     # #0a780a
C_CLEAN="\x1b[38;2;10;120;10m"    # green
C_DIRTY="\x1b[38;2;204;51;51m"    # red
C_MODEL="\x1b[38;2;150;150;150m"  # gray
C_RESET="\x1b[0m"

# Git info
GIT_INFO=""
if git -C "$DIR" rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null)

    # Git status summary
    STAGED=$(git -C "$DIR" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    UNSTAGED=$(git -C "$DIR" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    UNTRACKED=$(git -C "$DIR" ls-files --others --exclude-standard "$DIR" 2>/dev/null | wc -l | tr -d ' ')
    STASHED=$(git -C "$DIR" stash list 2>/dev/null | wc -l | tr -d ' ')

    STATUS=""
    [ "$STAGED" -gt 0 ] 2>/dev/null && STATUS="${STATUS}+${STAGED} "
    [ "$UNSTAGED" -gt 0 ] 2>/dev/null && STATUS="${STATUS}!${UNSTAGED} "
    [ "$UNTRACKED" -gt 0 ] 2>/dev/null && STATUS="${STATUS}?${UNTRACKED} "
    [ "$STASHED" -gt 0 ] 2>/dev/null && STATUS="${STATUS}*${STASHED} "

    # Ahead/behind origin
    AHEAD=0
    BEHIND=0
    UPSTREAM=$(git -C "$DIR" rev-parse --abbrev-ref "@{upstream}" 2>/dev/null)
    if [ -n "$UPSTREAM" ]; then
        AHEAD=$(git -C "$DIR" rev-list --count "$UPSTREAM..HEAD" 2>/dev/null || echo 0)
        BEHIND=$(git -C "$DIR" rev-list --count "HEAD..$UPSTREAM" 2>/dev/null || echo 0)
    fi

    [ "$AHEAD" -gt 0 ] 2>/dev/null && STATUS="${STATUS}↑${AHEAD} "
    [ "$BEHIND" -gt 0 ] 2>/dev/null && STATUS="${STATUS}↓${BEHIND} "

    STATUS=$(echo "$STATUS" | sed 's/ $//')

    if [ -z "$STATUS" ]; then
        STATUS_COLOR="$C_CLEAN"
        STATUS_MARKER=""
    else
        STATUS_COLOR="$C_DIRTY"
        STATUS_MARKER=" [${STATUS}]"
    fi

    GIT_INFO=" on ${C_BRANCH} ${BRANCH}${STATUS_COLOR}${STATUS_MARKER}${C_RESET}"
fi

# Current issue (from .state KEY=VALUE file)
ISSUE_INFO=""
STATE_FILE="$DIR/.state"
if [ -f "$STATE_FILE" ]; then
    ISSUE_NUM=$(grep '^ISSUE=' "$STATE_FILE" 2>/dev/null | cut -d= -f2- | tr -d '[:space:]')
    if [ -n "$ISSUE_NUM" ]; then
        # Derive GitHub repo URL from git remote
        REMOTE_URL=$(git -C "$DIR" remote get-url origin 2>/dev/null)
        REPO_URL=$(echo "$REMOTE_URL" | sed -E 's|git@github\.com:|https://github.com/|;s|\.git$||')
        ISSUE_URL="${REPO_URL}/issues/${ISSUE_NUM}"
        # OSC 8 clickable hyperlink
        ISSUE_INFO=" \x1b]8;;${ISSUE_URL}\x1b\\#${ISSUE_NUM}\x1b]8;;\x1b\\"
    fi
fi

# Node version
NODE_INFO=""
if command -v node > /dev/null 2>&1; then
    NODE_VER=$(node -v 2>/dev/null)
    NODE_INFO=" via ${C_NODE} ${NODE_VER}${C_RESET}"
fi

# Session cost
C_COST="\x1b[38;2;218;165;32m"  # goldenrod
COST_USD=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
COST_FMT=$(printf '$%.2f' "$COST_USD")
COST_INFO=" ${C_COST}${COST_FMT}${C_RESET}"

printf "${C_FOLDER}${FOLDER}${C_RESET}${GIT_INFO}${ISSUE_INFO}${NODE_INFO} [${C_MODEL}${MODEL}${C_RESET}]${COST_INFO}\n"
