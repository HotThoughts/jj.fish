# jj.fish 🌿

A Fish shell plugin for [jj (Jujutsu)](https://github.com/martinvonz/jj) that provides convenient abbreviations for common operations.

## Features

- **⚡ Quick abbreviations**: Fast shortcuts for common jj operations
- **🔧 Simple setup**: Just install and start using
- **🚀 Workflow-focused**: Covers the most frequently used jj commands

## Installation

### Prerequisites

| Tool | Purpose |
|------|---------|
| [Fish](https://fishshell.com/) | Shell environment (3.4.0+) |
| [jj](https://github.com/martinvonz/jj) | Version control (0.29.0+) |

### Install with Fisher

```fish
fisher install HotThoughts/jj.fish
```

## Abbreviations

Once installed, you can use these abbreviations in your Fish shell:

### Core Operations

| Abbreviation | Expands to | Description |
|--------------|------------|-------------|
| `jjl` | `jj log` | Show commit history |
| `jjll` | `jj log --limit` | Show limited commit history |
| `jjlr` | `jj log --revisions` | Show log for specific revisions |
| `jjst` | `jj st` | Show working copy status |
| `jjd` | `jj describe` | Edit change description |
| `jjdm` | `jj describe -m` | Set change description message |
| `jjnm` | `jj new main` | Create new change based on main |

### Git Integration

| Abbreviation | Expands to | Description |
|--------------|------------|-------------|
| `jjgic` | `jj git init --colocate` | Initialize colocated Git/jj repo |
| `jjgp` | `jj git push` | Push to Git remote |
| `jjgpc` | `jj git push --change` | Push specific change to Git remote |

### Legacy Abbreviations

These are also available for compatibility:

| Abbreviation | Expands to | Description |
|--------------|------------|-------------|
| `jgi` | `jj git init --colocate` | Initialize colocated repo |
| `jgp` | `jj git push` | Push to Git remote |
| `jd` | `jj describe -m` | Set change description |

## Quick Start

```fish
# Initialize a new repository
jjgic

# Check status
jjst

# View commit history
jjl

# Create a new change
jjnm

# Make some changes, then describe them
jjdm "feat: add new feature"

# Push to remote
jjgp
```

## Usage Examples

### Basic Workflow

```fish
# Start a new change
jjnm
# Equivalent to: jj new main

# Check what's changed
jjst
# Equivalent to: jj st

# View recent commits
jjll 5
# Equivalent to: jj log --limit 5

# Describe your changes
jjdm "fix: resolve issue with parsing"
# Equivalent to: jj describe -m "fix: resolve issue with parsing"

# Push to remote
jjgp
# Equivalent to: jj git push
```

### Git Integration

```fish
# Initialize a colocated repository
jjgic
# Equivalent to: jj git init --colocate

# Push a specific change
jjgpc @
# Equivalent to: jj git push --change @
```

### Exploring History

```fish
# View commit graph
jjl

# View specific revisions
jjlr main..@
# Equivalent to: jj log --revisions main..@

# Limited history view
jjll 10
# Equivalent to: jj log --limit 10
```

## How Abbreviations Work

Fish abbreviations expand when you press space or enter. For example:
1. Type `jjl`
2. Press space
3. Fish expands it to `jj log`
4. Continue typing your arguments

You can also see what an abbreviation expands to:
```fish
abbr --show jjl
# Shows: abbr jjl 'jj log'
```

## Customization

You can add your own jj abbreviations:

```fish
# Add custom abbreviations
abbr --add jjs 'jj show'
abbr --add jjco 'jj checkout'
abbr --add jjam 'jj abandon @'

# Remove abbreviations you don't want
abbr --erase jjnm
```

## Requirements

- **Fish shell**: Version 3.4.0 or later
- **jj (Jujutsu)**: Version 0.29.0 or later for full compatibility
- **Git**: Required for git integration features

The plugin will show warnings on startup if dependencies are missing, but core abbreviations will still work.

## Troubleshooting

### Abbreviations not working

Make sure the plugin is properly installed:

```fish
fisher list | grep jj.fish
```

If not found, reinstall:

```fish
fisher install HotThoughts/jj.fish
```

### "jj command not found"

Install jj following the [official installation guide](https://github.com/martinvonz/jj#installation).

### Git operations failing

Ensure you're in a repository with a Git remote configured:

```fish
jj git remote list
```

## Contributing

Suggestions for additional useful abbreviations are welcome! Please consider:
- Frequency of use
- Consistency with existing patterns  
- Avoiding conflicts with common commands

## License

MIT License - see [LICENSE](LICENSE) for details

## Credits

- [jj](https://github.com/martinvonz/jj) for the amazing VCS
- Fish shell community for abbreviation best practices