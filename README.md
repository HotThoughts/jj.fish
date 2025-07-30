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

## License

MIT