# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release of jj.fish plugin
- `jjbranch` function to create bookmarks with `push-<change-id>` format
- `jjpr` function for one-command branch creation, push, and PR opening
- `jgp` function as shortcut for `jj git push`
- `jj_configure` function for customizing plugin settings
- Configurable branch prefix and change ID length
- Comprehensive error handling and dependency checks
- Tab completions for `jj_configure` command
- Plugin initialization with dependency validation

### Features
- Smart branch naming using jj change IDs
- Automatic GitHub PR creation with proper titles
- Auto-assignment of PRs to current user
- Support for Fish shell 3.4.0+
- Compatible with jj 0.29.0+
- Integration with GitHub CLI

[Unreleased]: https://github.com/HotThoughts/jj.fish/compare/HEAD
