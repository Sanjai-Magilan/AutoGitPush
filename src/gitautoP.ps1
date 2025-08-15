# ================================
# AutoGitPush PowerShell Script
# -------------------------------
# This script automatically commits and pushes changes to a Git repository 
# whenever Visual Studio Code is running, checking at a set interval.
# ================================

# === CONFIGURATION LOADER ===
# Get the directory where the script is located
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$CONFIG_FILE = Join-Path (Split-Path -Parent $SCRIPT_DIR) "config\autogitpush.conf"

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
REPO_PATH="C:\path\to\your\repo"

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
    Write-Output "📋 Created default configuration file at: $CONFIG_FILE"
    Write-Output "✏️  Please edit the configuration file before running the script."
}

# Function to parse configuration file
function Parse-Config {
    $config = @{}
    if (Test-Path $CONFIG_FILE) {
        Get-Content $CONFIG_FILE | ForEach-Object {
            $line = $_.Trim()
            if ($line -match '^([A-Z_]+)="?([^"]*)"?.*$' -and -not $line.StartsWith('#')) {
                $config[$matches[1]] = $matches[2]
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
        $interval = [int]$config['CHECK_INTERVAL_MINUTES'] * 60
        Write-Output "⏱️  Using interval: $($config['CHECK_INTERVAL_MINUTES']) minutes ($interval seconds)"
    }
    elseif ($config.ContainsKey('CHECK_INTERVAL_HOURS')) {
        $interval = [int]([double]$config['CHECK_INTERVAL_HOURS'] * 3600)
        Write-Output "⏱️  Using interval: $($config['CHECK_INTERVAL_HOURS']) hours ($interval seconds)"
    }
    elseif ($config.ContainsKey('CHECK_INTERVAL_DAYS')) {
        $interval = [int]([double]$config['CHECK_INTERVAL_DAYS'] * 86400)
        Write-Output "⏱️  Using interval: $($config['CHECK_INTERVAL_DAYS']) days ($interval seconds)"
    }
    elseif ($config.ContainsKey('CHECK_INTERVAL')) {
        $interval = [int]$config['CHECK_INTERVAL']
        Write-Output "⏱️  Using interval: $($config['CHECK_INTERVAL']) seconds"
    }
    else {
        $interval = 1800  # Default 30 minutes
        Write-Output "⚠️  No interval configured, using default: 1800 seconds (30 minutes)"
    }
    
    return $interval
}

# Check if configuration file exists, if not create it
if (-not (Test-Path $CONFIG_FILE)) {
    Write-Output "⚙️  Configuration file not found. Creating default configuration..."
    Create-DefaultConfig
    Write-Output ""
    Write-Output "🛑 Please edit $CONFIG_FILE with your settings and run the script again."
    exit 1
}

# Load configuration from file
Write-Output "📖 Loading configuration from: $CONFIG_FILE"
$config = Parse-Config

# Extract configuration variables
$REPO_PATH = $config['REPO_PATH']
$BRANCH_NAME = $config['BRANCH_NAME']
$COMMIT_MESSAGE_PREFIX = $config['COMMIT_MESSAGE_PREFIX']
$CHECK_INTERVAL = Convert-ToSeconds -config $config

# Validate required configuration
if ($REPO_PATH -like "*path\to\your\repo*" -or $REPO_PATH -like "*path/to/your/repo*") {
    Write-Output "❌ Please configure REPO_PATH in $CONFIG_FILE"
    exit 1
}

Write-Output "🔧 Configuration loaded:"
Write-Output "   Repository: $REPO_PATH"
Write-Output "   Branch: $BRANCH_NAME"
Write-Output "   Commit Prefix: $COMMIT_MESSAGE_PREFIX"
Write-Output "   Check Interval: $CHECK_INTERVAL seconds"
Write-Output ""

# Infinite loop to continuously monitor VS Code
while ($true) {

    # Check if any process name starts with "Code" (Visual Studio Code)
    if (Get-Process | Where-Object { $_.ProcessName -like "Code*" }) {

        # Move to the Git repository directory
        Set-Location -Path $REPO_PATH

        # Check if there are any uncommitted changes using git status
        # --porcelain gives a simple output, so it's easy to check if there are changes
        if (-not ([string]::IsNullOrWhiteSpace((git status --porcelain)))) {

            # Create a commit message with the current date and time
            $TIMESTAMP = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            $COMMIT_MESSAGE = "$COMMIT_MESSAGE_PREFIX`: $TIMESTAMP"

            Write-Output "📦 Changes detected. Committing..."

            # Stage all changes (add new, modified, and deleted files)
            git add -A

            # Commit the staged changes
            git commit -m $COMMIT_MESSAGE

            # Push changes to the remote repository, targeting the configured branch
            git push origin $BRANCH_NAME

            # Output confirmation message with timestamp
            Write-Output "✅ Pushed to $BRANCH_NAME at $TIMESTAMP"
        } else {
            # Output message if there are no changes
            Write-Output "🔍 No changes to commit."
        }

    } else {
        # Output message if VS Code is not running
        Write-Output "💤 VS Code not running. Skipping..."
    }
    
    # Wait for the configured interval before checking again
    Start-Sleep -Seconds $CHECK_INTERVAL
}
