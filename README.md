# jj.fish 🌿

Fish shell abbreviations for [jj (Jujutsu)](https://github.com/martinvonz/jj) - fast shortcuts for common operations.

## Installation

```fish
fisher install HotThoughts/jj.fish
```

**Requirements:** Fish 3.4+, jj 0.29+

## Abbreviations

### Core Operations
| Abbr | Command | Abbr | Command |
|------|---------|------|---------|
| `jjl` | `jj log` | `jjst` | `jj st` |
| `jjll` | `jj log --limit` | `jjlr` | `jj log --revisions` |
| `jjd` | `jj describe` | `jjdm` | `jj describe -m` |
| `jjn` | `jj new` | `jjnm` | `jj new main` |
| `jjnmo` | `jj new main@origin` | `jja` | `jj abandon` |
| `jjr` | `jj rebase` | `jjrmo` | `jj rebase -d main@origin` |
| `jjc` | `jj commit` | `jjci` | `jj commit -i` |

### Viewing and Comparing
| Abbr | Command | Abbr | Command |
|------|---------|------|---------|
| `jjs` | `jj show` | `jjdf` | `jj diff` |
| `jjid` | `jj interdiff` | `jjev` | `jj evolog` |

### Editing Changes
| Abbr | Command | Abbr | Command |
|------|---------|------|---------|
| `jje` | `jj edit` | `jjsq` | `jj squash` |
| `jjsqi` | `jj squash -i` | `jjsp` | `jj split` |
| `jjde` | `jj diffedit` | `jjab` | `jj absorb` |

### Navigation
| Abbr | Command | Abbr | Command |
|------|---------|------|---------|
| `jjnx` | `jj next` | `jjpv` | `jj prev` |

### Bookmarks (Branches)
| Abbr | Command | Abbr | Command |
|------|---------|------|---------|
| `jjb` | `jj bookmark` | `jjbl` | `jj bookmark list` |
| `jjbs` | `jj bookmark set` | `jjbt` | `jj bookmark track` |
| `jjbd` | `jj bookmark delete` | | |

### Operations
| Abbr | Command | Abbr | Command |
|------|---------|------|---------|
| `jjop` | `jj op` | `jjopl` | `jj op log` |
| `jju` | `jj undo` | | |

### Conflict Resolution
| Abbr | Command | Abbr | Command |
|------|---------|------|---------|
| `jjrs` | `jj resolve` | `jjrt` | `jj restore` |

### Advanced Operations
| Abbr | Command | Abbr | Command |
|------|---------|------|---------|
| `jjdu` | `jj duplicate` | `jjrv` | `jj revert` |
| `jjpa` | `jj parallelize` | | |

### Git Integration
| Abbr | Command | Abbr | Command |
|------|---------|------|---------|
| `jjgic` | `jj git init --colocate` | `jjgp` | `jj git push` |
| `jjgpc` | `jj git push --change` | `jjgf` | `jj git fetch` |

### Short Alternatives
| Abbr | Command | Abbr | Command |
|------|---------|------|---------|
| `ji` | `jj git init --colocate` | `jp` | `jj git push` |
| `jf` | `jj git fetch` | `jd` | `jj describe -m` |
| `jr` | `jj rebase -d main@origin` | `jc` | `jj commit` |
| `jci` | `jj commit -i` | `jbt` | `jj bookmark track` |
| `jbs` | `jj bookmark set` | | |

### PR Creation
| Function | Description |
|----------|-------------|
| `jjpr [change-id]` | Push change and create GitHub PR (defaults to `@`) |

## Quick Start

```fish
# Initialize repo and start working
jjgic
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

## License

MIT