# jj.fish 🌿

A Fish shell plugin for [jj (Jujutsu)](https://github.com/martinvonz/jj) with shortcuts for common operations and GitHub PR automation.

## Features

- **🌿 Smart branch creation**: Create bookmarks with `push-<change-id>` format
- **🚀 One-command PR workflow**: Branch + push + PR creation in a single command
- **⚡ Quick shortcuts**: Fast access to common jj operations
- **🔧 Configurable**: Customize branch prefixes and change ID length
- **🛡️ Robust error handling**: Clear error messages and dependency checks

## Installation

### Prerequisites

| Tool | Minimum Version | Purpose |
|------|----------------|---------|
| [Fish](https://fishshell.com/) | 3.4.0+ | Shell environment |
| [jj](https://github.com/martinvonz/jj) | 0.29.0+ | Version control |
| [GitHub CLI](https://cli.github.com/) | 2.0.0+ | PR creation |

### Install with Fisher

```fish
fisher install HotThoughts/jj.fish
```

## Quick Start

```fish
# Make some changes
echo "Hello World" > hello.txt
jj commit -m "feat: add hello world"

# Create branch, push, and open PR in one command
jjpr

# Or do it step by step
jjbranch                    # Create push-mwmolltxkqkr bookmark
jgp --allow-new            # Push to GitHub
gh pr create --fill         # Create PR manually
```

## Commands

### `jjbranch`

Create a bookmark with format `push-<change-id>`:

```fish
jjbranch
# Creates: push-mwmolltxkqkr
```

### `jjpr`

Create bookmark, push to GitHub, and open pull request:

```fish
jjpr
```

This command:
1. 📝 Creates a bookmark named `push-<change-id>`
2. 🌱 Creates and checks out a matching Git branch if needed
3. 🚀 Pushes the bookmark and branch to GitHub
4. 🔗 Creates a PR using the jj change description as title
5. 👤 Auto-assigns the PR to you

> **Note:**  
> `jjpr` does not require a clean working directory. Only committed changes will be included in the pull request.

### `jgp`

Shortcut for `jj git push`:

```fish
jgp                         # jj git push
jgp --allow-new            # jj git push --allow-new
jgp --branch main          # jj git push --branch main
```

### `jj_configure`

Configure plugin settings:

```fish
jj_configure --help         # Show help
jj_configure               # Show current settings
jj_configure --prefix pr-  # Change branch prefix
jj_configure --length 8    # Change change ID length
jj_configure --reset       # Reset to defaults
```

## Configuration

### Branch Naming

Control how branches are named:

```fish
# Change branch prefix (default: "push-")
jj_configure --prefix "feature-"

# Change change ID length (default: 12)
jj_configure --length 8

# Result: feature-mwmolltx
```

### Manual Configuration

You can also set variables directly:

```fish
# In your config.fish
set -U jj_fish_branch_prefix "pr-"
set -U jj_fish_change_id_length 10
```

## Examples

### Basic Workflow

```fish
# Start working on a feature
jj new
echo "console.log('Hello')" > app.js
jj commit -m "feat: add hello world logging"

# Create PR
jjpr
# ✓ Created bookmark: push-abc123def456
# 🚀 Pushing to GitHub...
# 🔗 Creating pull request...
# ✅ Pull request created successfully!
```

### Custom Branch Naming

```fish
# Configure custom prefix
jj_configure --prefix "feature-" --length 8

# Create branch
jjbranch
# ✓ Created bookmark: feature-abc123de
```

### Step-by-Step Workflow

```fish
# Create bookmark only
jjbranch

# Make more changes...
echo "More code" >> app.js
jj commit -m "feat: add more functionality"

# Push when ready
jgp --allow-new

# Create PR manually with gh
gh pr create --fill --assignee @me
```

## Branch Naming Convention

The plugin generates branch names using this format:

```
{prefix}{change_id}
```

Where:
- **prefix**: Configurable prefix (default: `push-`)
- **change_id**: First N characters of jj change ID (default: 12)

### Examples

| Configuration | Change ID | Result |
|---------------|-----------|---------|
| `push-` + 12 chars | `mwmolltxkqkr...` | `push-mwmolltxkqkr` |
| `feature-` + 8 chars | `abc12345...` | `feature-abc12345` |
| `pr-` + 16 chars | `xyz98765...` | `pr-xyz98765abcd1234` |

## Error Handling

The plugin provides clear error messages:

```fish
jjpr
# Error: jj (Jujutsu) is not installed or not in PATH

jjbranch
# Error: Failed to get change ID. Are you in a jj repository?

jjpr
# Error: GitHub CLI (gh) is not installed or not in PATH

jjpr
# ⚠️  Warning: You have uncommitted changes. Only committed changes will be included in the pull request.
```

## Requirements

- **Git repository with GitHub remote**: Required for `jjpr`
- **GitHub CLI authentication**: Run `gh auth login` first
- **jj repository**: Commands must be run inside a jj-managed repository

## Troubleshooting

### "Failed to get change ID"

Make sure you're in a jj repository and have committed changes:

```fish
jj init
jj commit -m "initial commit"
jjbranch  # Should work now
```

### "Failed to push to GitHub"

Ensure your repository has a GitHub remote:

```fish
git remote -v  # Check for GitHub remote
jj git remote add origin https://github.com/username/repo.git
```

### "Failed to create pull request"

Check GitHub CLI authentication:

```fish
gh auth status
gh auth login  # If not authenticated
```

### "Why is my uncommitted work not in the PR?"

Only committed changes are included in the pull request.  
If you have uncommitted changes, commit them before running `jjpr` if you want them included.

## License

MIT License - see [LICENSE](LICENSE) for details

## Credits

Inspired by:
- [fzf.fish](https://github.com/PatrickF1/fzf.fish) for plugin structure
- [jj](https://github.com/martinvonz/jj) for the amazing VCS
- Fish shell community for best practices

