# 🔧 AutoGitPush Configuration Guide

## Configuration File Location
The configuration file is automatically created at:
- **Path**: `config/autogitpush.conf`
- **Template**: `config/autogitpush.conf.template`

## Configuration Options

### Required Settings

| Setting | Description | Example |
|---------|-------------|---------|
| `REPO_PATH` | Path to your Git repository | `"$HOME/myproject"` (Linux/macOS)<br>`"C:\Users\Name\myproject"` (Windows) |
| `BRANCH_NAME` | Git branch to push to | `"main"`, `"develop"`, `"feature-branch"` |
| `COMMIT_MESSAGE_PREFIX` | Prefix for auto-commit messages | `"Auto-commit"`, `"WIP"`, `"Save"` |

### Time Interval Settings

**Choose ONE time unit** and uncomment only that line:

#### 1. Seconds (Default)
```bash
CHECK_INTERVAL=1800  # 30 minutes in seconds
```

#### 2. Minutes
```bash
# CHECK_INTERVAL_MINUTES=30  # 30 minutes
```

#### 3. Hours  
```bash
# CHECK_INTERVAL_HOURS=0.5   # 0.5 hours (30 minutes)
```

#### 4. Days
```bash
# CHECK_INTERVAL_DAYS=0.02   # 0.02 days (approximately 30 minutes)
```

## Common Time Intervals

| Duration | Seconds | Minutes | Hours | Days |
|----------|---------|---------|-------|------|
| 5 minutes | `300` | `5` | `0.083` | `0.0035` |
| 10 minutes | `600` | `10` | `0.167` | `0.007` |
| 30 minutes | `1800` | `30` | `0.5` | `0.02` |
| 1 hour | `3600` | `60` | `1` | `0.042` |
| 2 hours | `7200` | `120` | `2` | `0.083` |

## Setup Instructions

1. **First Run**: The script will automatically create `config/autogitpush.conf` if it doesn't exist
2. **Edit Configuration**: Update the settings in the config file:
   ```bash
   # Edit the configuration
   nano config/autogitpush.conf  # Linux/macOS
   notepad config\autogitpush.conf  # Windows
   ```
3. **Run Script**: Execute the script after configuration
   ```bash
   ./src/gitautoB.sh     # Linux/macOS
   .\src\gitautoP.ps1    # Windows PowerShell
   ```

## Example Configuration

```bash
# ================================
# AutoGitPush Configuration File
# ================================

# Path to your local Git repository
REPO_PATH="$HOME/Documents/my-awesome-project"

# Branch to push changes to
BRANCH_NAME="main"

# Prefix for commit messages
COMMIT_MESSAGE_PREFIX="Auto-save"

# Time between checks - Using minutes for clarity
# CHECK_INTERVAL=1800  # 30 minutes in seconds
CHECK_INTERVAL_MINUTES=30  # 30 minutes
# CHECK_INTERVAL_HOURS=0.5   # 0.5 hours (30 minutes)
# CHECK_INTERVAL_DAYS=0.02   # 0.02 days (approximately 30 minutes)
```

## Validation

The script will validate your configuration and show:
- ✅ Configuration loaded successfully
- ❌ Configuration errors (invalid paths, missing settings)
- ⚠️ Warnings (using default values)

## Troubleshooting

### Config File Not Found
- The script automatically creates a default config file on first run
- Edit the created file and run the script again

### Invalid Repository Path
- Ensure the `REPO_PATH` points to a valid Git repository
- Use absolute paths for better reliability
- Check that the directory exists and contains a `.git` folder
