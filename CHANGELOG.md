# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2026-02-04

### Changed
- **LexC mode**: Updated to version 2.7.0 with major improvements to lexicalise-missing function

### Added
- **LexC mode**: External Divvun-SEE-helper.app for bypassing macOS sandbox restrictions
- **LexC mode**: Words without suggestions are now preserved in output
- **LexC mode**: Installation check for Divvun-SEE-helper.app with helpful error message
- **LexC mode**: Automatic cleanup of extra blank lines (max one blank line between entries)

### Fixed
- **LexC mode**: Sandbox permission errors when running external tools (hfst-lookup, missing.py)
- **LexC mode**: UTF-8 handling for Sámi languages with special characters
- **LexC mode**: Missing words were lost when no suggestions were found

### Technical
- Introduced clipboard-based IPC with base64-encoded JSON for sandbox communication
- Helper app uses original missing.py from giella-core (no code duplication)
- Proper UTF-8 locale settings (`LANG=en_US.UTF-8`) throughout the pipeline

## [0.2.3] - 2024-08-29

Previous releases - see git history for details.

[0.3.0]: https://github.com/divvun/see-modes/compare/v0.2.3...v0.3.0
[0.2.3]: https://github.com/divvun/see-modes/releases/tag/v0.2.3
