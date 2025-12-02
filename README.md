# jj.fish 🌿

Fish shell abbreviations for [jj (Jujutsu)](https://github.com/martinvonz/jj) - fast shortcuts for common operations.

## Installation

```fish
fisher install HotThoughts/jj.fish
```

**Requirements:** Fish 3.4+, jj 0.29+

## Abbreviations

### Core Operations

| Abbr    | Command              | Abbr    | Command                    |
| ------- | -------------------- | ------- | -------------------------- |
| `jjl`   | `jj log`             | `jjst`  | `jj st`                    |
| `jjll`  | `jj log --limit`     | `jjlr`  | `jj log --revisions`       |
| `jjd`   | `jj describe`        | `jjdm`  | `jj describe -m`           |
| `jjn`   | `jj new`             | `jjnm`  | `jj new main`              |
| `jjnmo` | `jj new main@origin` | `jja`   | `jj abandon`               |
| `jjr`   | `jj rebase`          | `jjrmo` | `jj rebase -d main@origin` |
| `jjc`   | `jj commit`          | `jjci`  | `jj commit -i`             |

### Viewing and Comparing

| Abbr   | Command        | Abbr   | Command     |
| ------ | -------------- | ------ | ----------- |
| `jjs`  | `jj show`      | `jjdf` | `jj diff`   |
| `jjid` | `jj interdiff` | `jjev` | `jj evolog` |

### Editing Changes

| Abbr    | Command        | Abbr   | Command     |
| ------- | -------------- | ------ | ----------- |
| `jje`   | `jj edit`      | `jjsq` | `jj squash` |
| `jjsqi` | `jj squash -i` | `jjsp` | `jj split`  |
| `jjde`  | `jj diffedit`  | `jjab` | `jj absorb` |

### Navigation

| Abbr   | Command   | Abbr   | Command   |
| ------ | --------- | ------ | --------- |
| `jjnx` | `jj next` | `jjpv` | `jj prev` |

### Bookmarks (Branches)

| Abbr   | Command              | Abbr   | Command             |
| ------ | -------------------- | ------ | ------------------- |
| `jjb`  | `jj bookmark`        | `jjbl` | `jj bookmark list`  |
| `jjbs` | `jj bookmark set`    | `jjbt` | `jj bookmark track` |
| `jjbd` | `jj bookmark delete` |        |                     |

### Operations

| Abbr   | Command   | Abbr    | Command     |
| ------ | --------- | ------- | ----------- |
| `jjop` | `jj op`   | `jjopl` | `jj op log` |
| `jju`  | `jj undo` |         |             |

### Conflict Resolution

| Abbr   | Command      | Abbr   | Command      |
| ------ | ------------ | ------ | ------------ |
| `jjrs` | `jj resolve` | `jjrt` | `jj restore` |

### Advanced Operations

| Abbr   | Command          | Abbr   | Command     |
| ------ | ---------------- | ------ | ----------- |
| `jjdu` | `jj duplicate`   | `jjrv` | `jj revert` |
| `jjpa` | `jj parallelize` |        |             |

### Short Alternatives

| Abbr  | Command                    | Abbr  | Command             |
| ----- | -------------------------- | ----- | ------------------- |
| `ji`  | `jj git init --colocate .`   | `jp`  | `jj git push`       |
| `jf`  | `jj git fetch`             | `jd`  | `jj describe -m`    |
| `jr`  | `jj rebase -d main@origin` | `jc`  | `jj commit`         |
| `jci` | `jj commit -i`             | `jbt` | `jj bookmark track` |
| `jbs` | `jj bookmark set`          |       |                     |

### PR Creation

| Function           | Description                                        |
| ------------------ | -------------------------------------------------- |
| `jjpr [change-id]` | Push change and create GitHub PR (defaults to `@`) |

## Quick Start

```fish
# Initialize repo and start working
ji
jjst

# Create new change, make edits, describe
jjnm
jjdm "feat: add feature"

# View history and diff
jjl
jjdf

# Push current change and create PR
jjpr
```

## How It Works

Type abbreviation + space → expands to full command:

- `jjl` + space → `jj log`
- `jjst` + space → `jj st`

## Customization

```fish
# Add your own
abbr --add jjs 'jj show'

# Remove unwanted ones
abbr --erase jjnm
```

## Troubleshooting

### "jj not found" error

The plugin requires jj to be installed and in your PATH.

**Install jj:**

```fish
# macOS
brew install jj

# Or from source
cargo install --git https://github.com/martinvonz/jj jj-cli
```

**Verify installation:**

```fish
jj --version
```

### "gh CLI not found" when using jjpr

The `jjpr` function requires the GitHub CLI to create pull requests.

**Install gh:**

```fish
# macOS
brew install gh

# Linux
sudo apt install gh
```

**Authenticate:**

```fish
gh auth login
```

### Abbreviations not working

1. **Check plugin is loaded:**

   ```fish
   abbr --show | grep jj
   ```

   Should show jj abbreviations.

2. **Reload Fish config:**

   ```fish
   source ~/.config/fish/config.fish
   ```

3. **Reinstall plugin:**
   ```fish
   fisher remove HotThoughts/jj.fish
   fisher install HotThoughts/jj.fish
   ```

### jjpr fails with "could not determine branch name"

This occurs when jj doesn't output the expected branch name format after pushing.

**Workaround:**

1. Push manually: `jj git push -c <change-id>`
2. Note the branch name from output
3. Create PR manually: `gh pr create --head <branch-name>`

**Report:** If this happens consistently, please file an issue with your jj version (`jj --version`).

### Using repositories with non-"main" default branches

The `jjpr` function automatically detects your repository's default branch (main, master, develop, etc.) and creates PRs against it. No configuration needed.

### Change ID not found

Ensure you're using a valid change ID from `jj log`:

```fish
jjl              # View change history
jjpr abc123def   # Use the change ID prefix (first 7-12 chars)
```

## Development

### Pre-commit Hooks

This project uses [pre-commit](https://pre-commit.com/) to run automated checks before pushing to ensure code quality.

**Setup (one-time):**

```fish
# Install pre-commit (if not already installed)
brew install pre-commit  # macOS
# or: pip install pre-commit

# Install the git pre-push hook
pre-commit install --hook-type pre-push
```

**What gets checked:**

- Fish shell syntax validation (`fish --no-execute`)
- Fish shell indentation (`fish_indent --check`)
- Trailing whitespace and end-of-file fixes
- YAML validity
- Test suite execution

**Manual runs:**

```fish
# Run all hooks on all files
pre-commit run --hook-stage pre-push --all-files

# Run specific hook
pre-commit run --hook-stage pre-push fish-syntax-check

# Auto-fix formatting issues
pre-commit run --hook-stage pre-push --all-files
```

**Integration with jj:**

Since jj doesn't natively trigger git hooks (see [jj issue #405](https://github.com/jj-vcs/jj/issues/405)), you can configure a `jj push` alias that runs pre-commit checks before pushing.

**Setup (one-time):**

Add this alias to `.jj/repo/config.toml`:

```toml
[aliases]
push = [
  "util",
  "exec",
  "--",
  "bash",
  "-c",
  "files=$(jj log -r 'main@origin..@' --no-graph --summary 2>/dev/null | grep -E '^[MAD] ' | awk '{print $2}' | sort -u | tr '\n' ' '); if [ -n \"$files\" ]; then pre-commit run --hook-stage pre-push --files $files && jj git push \"$@\"; else jj git push \"$@\"; fi",
  "--",
]
```

This alias runs pre-commit checks only on files changed in your commits (using `jj log -r 'main@origin..@'`), making it fast and efficient.

**Usage:**
```fish
jj push           # Runs pre-commit checks on changed files, then pushes
jj git push       # Bypasses checks (direct git push)
```

**Manual runs (all files):**
```fish
pre-commit run --hook-stage pre-push --all-files
```

**Manual runs (changed files only, using jj):**
```fish
# Get changed files from jj and run pre-commit on them
files=$(jj log -r 'main@origin..@' --no-graph --summary | grep -E '^[MAD] ' | awk '{print $2}' | sort -u)
pre-commit run --hook-stage pre-push --files $files
```

## License

MIT
