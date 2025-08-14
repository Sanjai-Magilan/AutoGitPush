#!/bin/bash

# ================================
# AutoGitPush Bash Script
# -------------------------------
# This script automatically commits and pushes changes to a Git repository 
# whenever Visual Studio Code is running, checking at a set interval.
# ================================

# === CONFIGURATION ===
REPO_PATH="$HOME/Public/AutoGitPush"   # Path to your local Git repository
BRANCH_NAME="trash"                    # Branch to push changes to
COMMIT_MESSAGE_PREFIX="Auto-commit"   # Prefix for commit messages
CHECK_INTERVAL=5                   # Time between checks (in seconds) — default is 30 minutes

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
