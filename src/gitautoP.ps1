# ================================
# AutoGitPush PowerShell Script
# -------------------------------
# This script automatically commits and pushes changes to a Git repository 
# whenever Visual Studio Code is running, checking at a set interval.
# ================================

# === CONFIGURATION LOADER ===
# Get the directory where the script is located

# ================================
# AutoGitPush PowerShell Script (Bash logic)
# ================================

# Get the directory where the script is located
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$CONFIG_FILE = Join-Path $SCRIPT_DIR "..\config\autogitpush.conf"

# Function to create default configuration file
function Create-DefaultConfig {
    $configDir = Split-Path -Parent $CONFIG_FILE
    if (-not (Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    }
    $configContent = @"
# ================================
# AutoGitPush Configuration File
# ================================
# Edit these values according to your needs

# Path to your local Git repository
REPO_PATH="C:\\path\\to\\your\\repo"

# Branch to push changes to
BRANCH_NAME="main"

# Prefix for commit messages
COMMIT_MESSAGE_PREFIX="Auto-commit"

# Time between checks - Choose ONE unit and uncomment it
# Uncomment the line with your preferred time unit and comment out others

# === SECONDS ===
CHECK_INTERVAL=1800  # 30 minutes in seconds

# === MINUTES ===
# CHECK_INTERVAL_MINUTES=30  # 30 minutes

# === HOURS ===
# CHECK_INTERVAL_HOURS=0.5   # 0.5 hours (30 minutes)

# === DAYS ===
# CHECK_INTERVAL_DAYS=0.02   # 0.02 days (approximately 30 minutes)
"@
    Set-Content -Path $CONFIG_FILE -Value $configContent -Encoding UTF8
    Write-Host "[Config] Created default configuration file at: $CONFIG_FILE"
    Write-Host "[Config] Please edit the configuration file before running the script."
}

# Function to parse configuration file
function Parse-Config {
    $config = @{}
    if (Test-Path $CONFIG_FILE) {
        Get-Content $CONFIG_FILE | ForEach-Object {
            $line = $_.Trim()
            if (-not $line.StartsWith('#') -and $line.Contains('=')) {
                $parts = $line -split '=', 2
                $key = $parts[0].Trim()
                $value = $parts[1].Trim()
                # Remove quotes if present
                $value = $value -replace '^"', '' -replace '"$', ''
                # Remove comments after the value
                $value = ($value -split '#')[0].Trim()
                $config[$key] = $value
            }
        }
    }
    return $config
}

# Function to convert time units to seconds
function Convert-ToSeconds {
    param($config)
    $interval = 0
    
    if ($config.ContainsKey('CHECK_INTERVAL_MINUTES')) {
        $minutes = [double]$config['CHECK_INTERVAL_MINUTES']
        $interval = [Math]::Round($minutes * 60)
        Write-Host "[Interval] Using interval: $minutes minutes ($interval seconds)"
    } elseif ($config.ContainsKey('CHECK_INTERVAL_HOURS')) {
        $hours = [double]$config['CHECK_INTERVAL_HOURS']
        $interval = [Math]::Round($hours * 3600)
        Write-Host "[Interval] Using interval: $hours hours ($interval seconds)"
    } elseif ($config.ContainsKey('CHECK_INTERVAL_DAYS')) {
        $days = [double]$config['CHECK_INTERVAL_DAYS']
        $interval = [Math]::Round($days * 86400)
        Write-Host "[Interval] Using interval: $days days ($interval seconds)"
    } elseif ($config.ContainsKey('CHECK_INTERVAL')) {
        $interval = [int]$config['CHECK_INTERVAL']
        Write-Host "[Interval] Using interval: $interval seconds"
    } else {
        $interval = 1800  # Default 30 minutes
        Write-Host "[Interval] No interval configured, using default: 1800 seconds (30 minutes)"
    }
    
    # Minimum interval validation - enforce at least 30 seconds
    if ($interval -lt 30) {
        Write-Host "[Warning] Configured interval ($interval seconds) is less than minimum (30 seconds). Using 30 seconds instead."
        $interval = 30
    }
    
    return $interval
}

# Check if configuration file exists, if not create it
if (-not (Test-Path $CONFIG_FILE)) {
    Write-Output "[Config] Configuration file not found. Creating default configuration..."
    Create-DefaultConfig
    Write-Output ""
    Write-Output "[Config] Please edit $CONFIG_FILE with your settings and run the script again."
    exit 1
}

# Load configuration from file
Write-Output "[Config] Loading configuration from: $CONFIG_FILE"
$config = Parse-Config

# Extract configuration variables
$REPO_PATH = $config['REPO_PATH']
$BRANCH_NAME = $config['BRANCH_NAME']
$COMMIT_MESSAGE_PREFIX = $config['COMMIT_MESSAGE_PREFIX']
$CHECK_INTERVAL = Convert-ToSeconds -config $config

# Validate required configuration
if ($REPO_PATH -like "*path\\to\\your\\repo*" -or $REPO_PATH -like "*path/to/your/repo*" -or $REPO_PATH -like "*C:\\path\\to\\your\\repo*") {
    Write-Output "[Config] Please configure REPO_PATH in $CONFIG_FILE"
    exit 1
}

Write-Output "[Config] Configuration loaded:"
Write-Output "   Repository: $REPO_PATH"
Write-Output "   Branch: $BRANCH_NAME"
Write-Output "   Commit Prefix: $COMMIT_MESSAGE_PREFIX"
Write-Output "   Check Interval: $CHECK_INTERVAL seconds"
Write-Output ""

# === SCRIPT START ===
while ($true) {
    # Check if VS Code is running by looking for "Code" in the process list
    $vscodeRunning = Get-Process | Where-Object { $_.ProcessName -like "Code*" }
    if ($vscodeRunning) {
        # Change directory to the repository
        if (-not (Test-Path $REPO_PATH)) {
            Write-Output "[Error] Repo path not found: $REPO_PATH"
            exit 1
        }
        Set-Location -Path $REPO_PATH

        # Check if there are any uncommitted changes
        $gitStatus = git status --porcelain
        if ($gitStatus -and $gitStatus.Trim().Length -gt 0) {
            # Create a commit message with current date and time
            $TIMESTAMP = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            $COMMIT_MESSAGE = "${COMMIT_MESSAGE_PREFIX}: $TIMESTAMP"

            Write-Output "[Git] Changes detected. Committing..."

            # Stage all changes (new, modified, deleted files)
            git add -A

            # Commit the staged changes
            git commit -m "$COMMIT_MESSAGE"

            # Push to the specified branch
            git push origin "$BRANCH_NAME"

            Write-Output "[Git] Pushed to $BRANCH_NAME at $TIMESTAMP"
        } else {
            # No changes detected
            Write-Output "[Git] No changes to commit."
        }
    } else {
        # VS Code not running
        Write-Output "[Info] VS Code not running. Skipping..."
    }
    # Wait for the defined interval before checking again
    Start-Sleep -Seconds $CHECK_INTERVAL
}
