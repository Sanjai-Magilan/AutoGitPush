#!/bin/bash

# ================================
# AutoGitPush Bash Script
# -------------------------------
# This script automatically commits and pushes changes to a Git repository 
# whenever Visual Studio Code is running, checking at a set interval.
# ================================

# === CONFIGURATION LOADER ===
# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../config/autogitpush.conf"

# Function to create default configuration file
create_default_config() {
    mkdir -p "$(dirname "$CONFIG_FILE")"
    cat > "$CONFIG_FILE" << 'EOF'
# ================================
# AutoGitPush Configuration File
# ================================
# Edit these values according to your needs

# Path to your local Git repository
REPO_PATH="$HOME/path/to/your/repo"

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
EOF
    echo "📋 Created default configuration file at: $CONFIG_FILE"
    echo "✏️  Please edit the configuration file before running the script."
}

# Function to convert time units to seconds
convert_to_seconds() {
    local interval=0
    
    # Check which time unit is configured
    if [[ -n "$CHECK_INTERVAL_MINUTES" ]]; then
        interval=$(echo "$CHECK_INTERVAL_MINUTES * 60" | bc -l | cut -d. -f1)
        echo "⏱️  Using interval: $CHECK_INTERVAL_MINUTES minutes ($interval seconds)"
    elif [[ -n "$CHECK_INTERVAL_HOURS" ]]; then
        interval=$(echo "$CHECK_INTERVAL_HOURS * 3600" | bc -l | cut -d. -f1)
        echo "⏱️  Using interval: $CHECK_INTERVAL_HOURS hours ($interval seconds)"
    elif [[ -n "$CHECK_INTERVAL_DAYS" ]]; then
        interval=$(echo "$CHECK_INTERVAL_DAYS * 86400" | bc -l | cut -d. -f1)
        echo "⏱️  Using interval: $CHECK_INTERVAL_DAYS days ($interval seconds)"
    elif [[ -n "$CHECK_INTERVAL" ]]; then
        interval=$CHECK_INTERVAL
        echo "⏱️  Using interval: $CHECK_INTERVAL seconds"
    else
        interval=1800  # Default 30 minutes
        echo "⚠️  No interval configured, using default: 1800 seconds (30 minutes)"
    fi
    
    # Minimum interval validation - enforce at least 30 seconds
    if [[ $interval -lt 10 ]]; then
        echo "⚠️  Configured interval ($interval seconds) is less than minimum (30 seconds). Using 30 seconds instead."
        interval=30
    fi
    
    CHECK_INTERVAL=$interval
}

# Check if configuration file exists, if not create it
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "⚙️  Configuration file not found. Creating default configuration..."
    create_default_config
    echo ""
    echo "🛑 Please edit $CONFIG_FILE with your settings and run the script again."
    exit 1
fi

# Load configuration from file
echo "📖 Loading configuration from: $CONFIG_FILE"
source "$CONFIG_FILE"

# Convert time units to seconds
convert_to_seconds

# Validate required configuration
if [[ "$REPO_PATH" == *"path/to/your/repo"* ]]; then
    echo "❌ Please configure REPO_PATH in $CONFIG_FILE"
    exit 1
fi

echo "🔧 Configuration loaded:"
echo "   Repository: $REPO_PATH"
echo "   Branch: $BRANCH_NAME"
echo "   Commit Prefix: $COMMIT_MESSAGE_PREFIX"
echo "   Check Interval: $CHECK_INTERVAL seconds"
echo ""

# === SCRIPT START ===
while true; do
    # Check if VS Code is running by looking for "code" in the process list
    if pgrep -f "code" > /dev/null; then
        
        # Change directory to the repository
        cd "$REPO_PATH" || {
            echo "❌ Repo path not found: $REPO_PATH"
            exit 1
        }

        # Check if there are any uncommitted changes
        if git status --porcelain | grep -q .; then
            # Create a commit message with current date and time
            TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
            COMMIT_MESSAGE="$COMMIT_MESSAGE_PREFIX: $TIMESTAMP"

            echo "📦 Changes detected. Committing..."

            # Stage all changes (new, modified, deleted files)
            git add -A

            # Commit the staged changes
            git commit -m "$COMMIT_MESSAGE"

            # Push to the specified branch
            git push origin "$BRANCH_NAME"

            echo "✅ Pushed to $BRANCH_NAME at $TIMESTAMP"
        else
            # No changes detected
            echo "🔍 No changes to commit."
        fi
    else
        # VS Code not running
        echo "💤 VS Code not running. Skipping..."
    fi

    # Wait for the defined interval before checking again
    sleep "$CHECK_INTERVAL"
done