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

Automatically generates conventional commit messages by analyzing your changes using direct API calls. Fast and reliable (typically 1-3 seconds).

**Features:**
- Fast: Direct API calls (1-3s vs 5-15s with agent tools)
- Smart: Analyzes diffs and generates conventional commit messages
- Auto-detection: Automatically uses available API keys
- Configurable: Customize models and providers
- Optimized: Automatically truncates large diffs to stay within token limits

**Supported AI providers:**
- **OpenAI** (`openai`) - Fast and cost-effective option
- **Anthropic** (`anthropic`) - High-quality Claude models
- **DeepSeek** (`deepseek`) - Cost-effective alternative

**Setup:**

First, get an API key from one or more providers:
- OpenAI: https://platform.openai.com/api-keys
- Anthropic: https://console.anthropic.com/settings/keys
- DeepSeek: https://platform.deepseek.com/api_keys

Then set the API key(s) in your Fish shell (these persist across sessions):
```fish
set -Ux OPENAI_API_KEY "sk-..."
# or
set -Ux ANTHROPIC_API_KEY "sk-ant-..."
# or
set -Ux DEEPSEEK_API_KEY "sk-..."
```

You can customize the model if you want:
```fish
set -Ux JJ_AI_OPENAI_MODEL "gpt-4o-mini"              # Default: gpt-4o-mini
set -Ux JJ_AI_ANTHROPIC_MODEL "claude-3-5-haiku-20241022"  # Default: claude-3-5-haiku-20241022
set -Ux JJ_AI_DEEPSEEK_MODEL "deepseek-chat"          # Default: deepseek-chat
```

If you have multiple providers set up, you can skip the selection prompt by setting a preferred one:
```fish
set -Ux JJ_AI_TOOL openai  # Options: openai, anthropic, deepseek
```

**Usage:**

```fish
# Generate and set description (with confirmation)
jjad

# Generate and commit (with confirmation)
jjac

# If multiple providers are available, you'll get an interactive selection:
# Multiple AI providers detected. Select one:
#   1) openai
#   2) anthropic
#   3) deepseek
# Choice [1-3]:
```

**How it works:**

When you run `jjad` or `jjac`, it analyzes your current changes using `jj diff`, sends the diff to your selected AI provider, generates a conventional commit message, shows you a preview for confirmation, and then applies it via `jj describe` or `jj commit`.

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

**"No AI API keys found" error:**

You need to set at least one API key:
```fish
set -Ux OPENAI_API_KEY "sk-..."
# or
set -Ux ANTHROPIC_API_KEY "sk-ant-..."
# or
set -Ux DEEPSEEK_API_KEY "sk-..."
```

**"API request failed" error:**

First, check that your API key is valid:
```fish
echo $OPENAI_API_KEY  # Should show your key
```

Then test network connectivity:
```fish
curl -I https://api.openai.com/v1/models  # Test OpenAI
curl -I https://api.anthropic.com/v1/messages  # Test Anthropic
curl -I https://api.deepseek.com/v1/models  # Test DeepSeek
```

Also make sure your API key has access to chat completions/messages endpoints. If you hit rate limits, wait a moment and try again, or use a different provider.

**"Failed to parse API response" error:**

This usually means there's an API error. Check that:
- Your API key is correct and has sufficient credits
- The model name is valid (if you customized `JJ_AI_*_MODEL`)
- The API service is operational

**Slow performance:**

The feature uses direct API calls and should be fast (1-3 seconds). If it's slow, check your internet connection. Large diffs are automatically truncated, but very large repos may still be slow. You can also try a different provider since some are faster than others.

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
