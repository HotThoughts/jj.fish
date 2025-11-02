# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- Rewrote `jjpr` function with robust error handling and dependency checking
- Replaced fragile grep/awk/sed parsing with Fish native string operations
- Improved error messages with proper stderr redirection
- Enhanced plugin initialization with better dependency checking and error messages
- Organized abbreviations with clear grouping and inline documentation

### Added
- Automated test suite with test runner script
- Tests for abbreviations, functions, and initialization
- CI integration for automated testing
- Dependency check for gh CLI in plugin initialization
- Installation URLs in error messages for missing dependencies

### Removed
- Orphaned `completions/jj_configure.fish` file (command was never implemented)

### Fixed
- Exit code validation in `jjpr` function
- Branch name extraction logic in `jjpr` function
- Error handling for invalid change IDs
- Missing dependency checks before command execution
- Hard-coded "main" branch in `jjpr` - now auto-detects repository default branch

## [0.3.0] - 2024-11-02

### Added
- More abbreviations for common jj operations (#9)

### Changed
- Updated GitHub Actions checkout from v4 to v5 (#10)

## [0.2.0] - 2024-11-02

### Added
- GitHub PR creation functionality with `jjpr` command (#8)

### Changed
- Code cleanup and refactoring (#7)

## [0.1.0] - 2024-06-05

### Added
- Initial abbreviations for jj commands (#6)
- Fish shell plugin structure
- Fisher plugin manager support
- CI/CD pipeline with GitHub Actions
- Basic documentation

### Fixed
- Release workflow CD issues (#5)

### Changed
- Updated fish-shop actions to latest versions (#2, #3, #4)

[Unreleased]: https://github.com/HotThoughts/jj.fish/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/HotThoughts/jj.fish/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/HotThoughts/jj.fish/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/HotThoughts/jj.fish/releases/tag/v0.1.0
