#!/bin/bash
set -euo pipefail

# Generic git worktree bootstrapper.
# Creates a worktree, symlinks env files / certs / Claude Code settings,
# then runs a project-local worktree-post-setup.sh if one exists.
#
# Usage: worktree-setup.sh <path> <branch-name>
#   e.g. worktree-setup.sh ../myapp-feature feat/my-new-branch

if [ $# -lt 2 ]; then
  echo "Usage: worktree-setup.sh <path> <branch-name>"
  echo "  e.g. worktree-setup.sh ../myapp-feature feat/my-new-branch"
  exit 1
fi

WORKTREE_PATH="$1"
BRANCH_NAME="$2"
MAIN_WORKTREE="$(git worktree list --porcelain | head -1 | sed 's/worktree //')"

# --- Create the worktree with a new branch ---
echo "Creating worktree at $WORKTREE_PATH on new branch '$BRANCH_NAME'..."
git worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH"

WORKTREE_ROOT="$(cd "$WORKTREE_PATH" && pwd)"
echo ""
echo "Main worktree: $MAIN_WORKTREE"
echo "New worktree:  $WORKTREE_ROOT"
echo ""

# --- Symlink env files ---
echo "Symlinking env files..."
for envfile in "$MAIN_WORKTREE"/.env.*; do
  [ -f "$envfile" ] || continue
  basename="$(basename "$envfile")"
  ln -sf "$envfile" "$WORKTREE_ROOT/$basename"
  echo "  $basename"
done

# SSL certs (*.pem)
for pemfile in "$MAIN_WORKTREE"/*.pem; do
  [ -f "$pemfile" ] || continue
  ln -sf "$pemfile" "$WORKTREE_ROOT/$(basename "$pemfile")"
  echo "  $(basename "$pemfile")"
done
echo ""

# --- Claude Code: share permissions and memory across worktrees ---
echo "Setting up Claude Code..."

# Symlink .claude/settings.local.json so permissions carry over
if [ -f "$MAIN_WORKTREE/.claude/settings.local.json" ]; then
  mkdir -p "$WORKTREE_ROOT/.claude"
  ln -sf "$MAIN_WORKTREE/.claude/settings.local.json" "$WORKTREE_ROOT/.claude/settings.local.json"
  echo "  .claude/settings.local.json (permissions)"
fi

# Symlink ~/.claude/projects/ entry so memory and history carry over
# Claude keys project data by absolute path, replacing / with -
MAIN_PROJECT_KEY="$(echo "$MAIN_WORKTREE" | sed 's|/|-|g')"
WORKTREE_PROJECT_KEY="$(echo "$WORKTREE_ROOT" | sed 's|/|-|g')"
CLAUDE_PROJECTS_DIR="$HOME/.claude/projects"

if [ -d "$CLAUDE_PROJECTS_DIR/$MAIN_PROJECT_KEY" ]; then
  ln -sfn "$CLAUDE_PROJECTS_DIR/$MAIN_PROJECT_KEY" "$CLAUDE_PROJECTS_DIR/$WORKTREE_PROJECT_KEY"
  echo "  ~/.claude/projects/ (shared memory)"
fi

echo ""

# --- Project-specific post-setup hook ---
if [ -f "$MAIN_WORKTREE/worktree-post-setup.sh" ]; then
  echo "Running project post-setup..."
  (cd "$WORKTREE_ROOT" && bash "$MAIN_WORKTREE/worktree-post-setup.sh" "$WORKTREE_ROOT" "$MAIN_WORKTREE")
  echo ""
fi

echo "Done! cd $WORKTREE_PATH"
