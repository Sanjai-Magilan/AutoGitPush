# Changelog
All notable changes to this project will be documented here.

## [0.1.0] - 2025-08-25
### Added
- Implemented auto-termination: program exits if no changes are detected for more than 45 minutes.
- Implemented CI/CD workflow for testing (currently only for Linux version).
- Program now pulls from the branch at the initial start.
  
### Changed
- Removed dependency on VS Code being open → program now runs standalone.
- Removed redundant cd repo path command from the loop.
- Initialized last commit time to the current time at startup to prevent premature termination when running once.

## [0.0.3] - 2025-08-15
### Added
- Configuration file system with `config/autogitpush.conf`
- Support for multiple time units (seconds, minutes, hours, days)
- Auto-creation of configuration file if missing
- Configuration validation and helpful error messages

### Changed
- Scripts now read settings from external configuration file
- Improved user experience with clear status messages
- Enhanced time interval handling with automatic conversion

## [0.0.2] - 2025-08-14
### Changed
- Renamed `gitauto.sh` to `gitautoB.sh` (B for Bash).
- Renamed `github.ps1` to `gitautoP.ps1` (P for PowerShell).
- Updated documentation and references to use new file names.
- Added comments in bash script for clarity.
- Added comments in PowerShell script for clarity.
- Verified PowerShell script functionality.
- Verified Bash script functionality.

## [0.0.1] - 2025-08-14
### Added
- Initial release of AutoGitPush.
- Shell script for Linux/macOS.
- PowerShell script for Windows.
- MIT License.

---
