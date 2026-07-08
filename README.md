# jj.fish

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
| `ji`  | `jj git init --colocate .` | `jp`  | `jj git push`             |
| `jf`  | `jj git fetch`             | `jnm` | `jj new main@origin`      |
| `jd`  | `jj describe -m`           | `jr`  | `jj rebase -d main@origin`|
| `jc`  | `jj commit`                | `jci` | `jj commit -i`            |
| `jbt` | `jj bookmark track`        | `jbs` | `jj bookmark set`         |

### AI-Powered Commit Messages

| Function | Description                                              |
| -------- | -------------------------------------------------------- |
| `jjad`   | AI-generated description via `jj describe`              |
| `jjac`   | AI-generated commit via `jj commit`                     |

Automatically generates conventional commit messages by piping your diff to whichever AI CLI tool you already have installed and authenticated — no separate API keys required.

**Features:**
- No extra setup: reuses your existing CLI login (Copilot, Cursor, or Claude)
- Smart: Analyzes diffs and generates conventional commit messages
- Auto-detection: Picks the tool automatically, or lets you choose if more than one is available
- Responsive: Shows a spinner while generating, with a 10s timeout so it never hangs

**Supported AI CLI tools:**
- **GitHub Copilot CLI** (`copilot`) - https://github.com/github/copilot-cli
- **Cursor Agent CLI** (`cursor-agent`) - https://cursor.com/cli
- **Claude Code CLI** (`claude`) - https://claude.com/claude-code
- **Codex CLI** (`codex`) - https://github.com/openai/codex

**Setup:**

Install and authenticate at least one of the CLI tools above, following that tool's own login flow. jj.fish auto-detects whichever ones are on your `$PATH`.

If you have more than one installed, you can skip the selection prompt by setting a preferred one:
```fish
set -Ux JJ_AI_TOOL claude  # Options: copilot, cursor-agent, claude, codex
```

**Usage:**

```fish
# Generate and set description (with confirmation)
jjad

# Generate and commit (with confirmation)
jjac

# If multiple tools are available, you'll get an interactive selection:
# Multiple AI tools detected. Select one:
#   1) copilot
#   2) cursor-agent
#   3) claude
#   4) codex
# Choice [1-4]:
```

**How it works:**

When you run `jjad` or `jjac`, it analyzes your current changes using `jj diff`, pipes the diff to your selected AI CLI tool, generates a conventional commit message, shows you a preview for confirmation, and then applies it via `jj describe` or `jj commit`.

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

Make sure jj is installed and in your PATH.

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

You'll need the GitHub CLI installed to use `jjpr`.

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

First, check if the plugin is loaded:
```fish
abbr --show | grep jj
```
This should show your jj abbreviations.

If not, try reloading your Fish config:
```fish
source ~/.config/fish/config.fish
```

If that doesn't work, reinstall the plugin:
```fish
fisher remove HotThoughts/jj.fish
fisher install HotThoughts/jj.fish
```

### jjpr fails with "could not determine branch name"

Sometimes jj doesn't output the branch name in the expected format after pushing. If this happens:

1. Push manually: `jj git push -c <change-id>`
2. Note the branch name from the output
3. Create the PR manually: `gh pr create --head <branch-name>`

If this happens consistently, please file an issue with your jj version (`jj --version`).

### Using repositories with non-"main" default branches

The `jjpr` function automatically detects your repository's default branch (main, master, develop, etc.) and creates PRs against it. You don't need to configure anything.

### Change ID not found

Make sure you're using a valid change ID from `jj log`:

```fish
jjl              # View change history
jjpr abc123def   # Use the change ID prefix (first 7-12 chars)
```

### AI commit message generation fails

**"No AI CLI tool found" error:**

Install and authenticate at least one of:
- GitHub Copilot CLI: https://github.com/github/copilot-cli
- Cursor Agent CLI: https://cursor.com/cli
- Claude Code CLI: https://claude.com/claude-code
- Codex CLI: https://github.com/openai/codex

**Nothing happens / times out after 10s:**

Make sure the CLI tool you selected is authenticated — run it directly once outside of jj.fish to confirm it works and complete any login flow.

**Slow performance:**

Response time depends on the underlying CLI tool. Large diffs may take longer regardless of which tool you use.

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

- Fish shell syntax validation
- Fish shell indentation
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

Since jj doesn't natively trigger git hooks (see [jj issue #405](https://github.com/jj-vcs/jj/issues/405)), you can configure a jj alias to run pre-commit checks on jj-tracked changed files.

**Setup (one-time):**

Add this alias to `.jj/repo/config.toml`:

```toml
[aliases]
pre-commit = [
  "util",
  "exec",
  "--",
  "fish",
  "-c",
  "jj diff -r @ --name-only --no-pager | xargs pre-commit run --files",
]
```

This alias runs pre-commit checks only on files changed in your current change, making it fast and efficient.

**Usage:**
```fish
jj pre-commit     # Runs pre-commit checks on changed files in current change
```

**Manual runs (all files):**
```fish
pre-commit run --hook-stage pre-push --all-files
```

**Manual runs (changed files only, using jj):**
```fish
# Get changed files from jj and run pre-commit on them
jj diff -r @ --name-only --no-pager | xargs pre-commit run --files
```

## License

MIT
