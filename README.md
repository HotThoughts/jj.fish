# jj.fish 🌿

Fish shell abbreviations for [jj (Jujutsu)](https://github.com/martinvonz/jj) - fast shortcuts for common operations.

## Installation

```fish
fisher install HotThoughts/jj.fish
```

**Requirements:** Fish 3.4+, jj 0.29+

## Abbreviations

### Core Operations
| `jjl` | `jj log` | `jjst` | `jj st` |
|-------|----------|--------|---------|
| `jjll` | `jj log --limit` | `jjd` | `jj describe` |
| `jjlr` | `jj log --revisions` | `jjdm` | `jj describe -m` |
| `jjnm` | `jj new main` | | |

### Git Integration
| `jjgic` | `jj git init --colocate` | `jjgp` | `jj git push` |
|---------|--------------------------|--------|---------------|
| `jjgpc` | `jj git push --change` | | |

### Short Alternatives
| `jgi` | `jj git init --colocate` | `jgp` | `jj git push` |
|-------|--------------------------|-------|---------------|
| `jd` | `jj describe -m` | | |

### PR Creation
| `jjpr <change-id>` | Push change and create GitHub PR |
|--------------------|----------------------------------|

## Quick Start

```fish
# Initialize repo and start working
jjgic
jjst

# Create new change, make edits, describe
jjnm
jjdm "feat: add feature"

# View history, push and create PR
jjl
jjpr <change-id>
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

## License

MIT