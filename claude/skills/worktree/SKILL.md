---
description: Create and manage git worktrees for parallel development. Handles branch naming, env setup, and worktree lifecycle.
context: fork
allowed-tools: Bash, Read, Glob, Grep
---

# /worktree — Git Worktree Management

## Usage

- `/worktree <issue-number>` — fetch issue, create worktree named from issue title, output launch command
- `/worktree <name>` — create worktree with the given name (no issue)
- `/worktree list` — list active worktrees
- `/worktree remove <path>` — remove a worktree
- `/worktree done` — clean up the current worktree and return to main

**Argument detection:** If the argument is purely numeric, treat it as a GitHub issue number. Otherwise treat it as a direct name/slug.

## Creating a Worktree

### 1. Preflight checks

Verify the repo is ready before creating a worktree:

1. **Determine repo name:**

    ```bash
    REPO=$(basename "$(git rev-parse --show-toplevel)")
    ```

2. **Check we're on main:**

    ```bash
    git branch --show-current
    ```

    If not on `main`, halt and tell the user.

3. **Check working tree is clean:**

    ```bash
    git status --porcelain
    ```

    If there are uncommitted changes, ask the user: proceed anyway or halt?

4. **Sync with origin:**

    ```bash
    git fetch origin main
    ```

    Compare local and remote:

    ```bash
    git rev-list --left-right --count main...origin/main
    ```

    - If local is behind, run `git pull` to catch up.
    - If local is ahead, warn the user (unpushed commits) and ask whether to proceed or halt.

### 2. Determine names

#### From an issue (numeric argument)

```bash
gh issue view <number> --json title,body,labels,comments,assignees
```

Display a brief summary (title + labels). Use the title and labels to derive names:

- Slugify the title (lowercase, hyphens, max ~40 chars): e.g. "Add horse filtering" → `add-horse-filtering`
- Branch prefix from labels (first match wins):
    - `bug` → `fix/`
    - `documentation` → `docs/`
    - `chore` or `maintenance` → `chore/`
    - `refactor` → `refactor/`
    - No matching label → `feat/`
- Branch: `<prefix><issue-number>-<slug>` (e.g. `fix/42-login-crash`, `chore/15-add-sentry`)
- Path: `../<repo>-<issue-number>-<slug>` (e.g. `../myapp-42-login-crash`)

#### From a name (non-numeric argument)

If the argument contains a recognized prefix (`feat/`, `fix/`, `chore/`, `docs/`, `refactor/`), use it as-is:

- `/worktree chore/add-sentry` → Branch: `chore/add-sentry`, Path: `../<repo>-add-sentry`
- `/worktree docs/update-readme` → Branch: `docs/update-readme`, Path: `../<repo>-update-readme`

If no recognized prefix, default to `feat/`:

- `/worktree some-feature` → Branch: `feat/some-feature`, Path: `../<repo>-some-feature`

### 3. Create worktree

If a `worktree-setup.sh` script exists in the repo root, use it:

```bash
./worktree-setup.sh ../<repo>-<slug> <branch>
```

Otherwise, create the worktree directly:

```bash
git worktree add -b <branch> ../<repo>-<slug>
```

### 4. Store tracking state

```bash
WORKTREE=$(cd ../<repo>-<slug> && pwd)
```

Write `.state` file. Include `ISSUE` only if an issue number was provided:

- **With issue:** `printf "ISSUE=<issue_number>\nWORKTREE=%s\n" "$WORKTREE" > .state`
- **Without issue:** `printf "WORKTREE=%s\n" "$WORKTREE" > .state`

### 5. Output the launch command

Print a message like:

```
Worktree is ready. Here is the launch command:

cd ../<repo>-<slug> && claude
```

**Stop here.** Do not continue with implementation. The user will launch a new Claude session in the worktree.

## Done — Clean Up Current Worktree

When the user runs `/worktree done`:

1. **Read the current worktree path:**

    ```bash
    grep '^WORKTREE=' .state | cut -d= -f2-
    ```

    If `.state` is missing or has no `WORKTREE` value, tell the user there's no active worktree to clean up.

2. **Kill any running dev servers** in that worktree (check for node processes on the worktree's ports).

3. **Remove the worktree:**

    ```bash
    git worktree remove <path>
    git worktree prune
    ```

    If it fails due to uncommitted changes, warn the user and ask whether to force-remove.

4. **Clear tracking files:**

    ```bash
    rm -f .state
    ```

5. **Confirm** the cleanup is complete. The user is now back in the main worktree.

## Listing / Removing

```bash
git worktree list
git worktree remove <path>        # clean removal
git worktree remove --force <path> # dirty worktree
git worktree prune                 # stale entries
```
