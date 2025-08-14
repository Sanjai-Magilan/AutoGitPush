#!/bin/bash

# === CONFIGURATION ===
REPO_PATH="$HOME/path/to/your/repo"   # Path to your local Git repo
BRANCH_NAME="main"                    # Branch to push changes to
COMMIT_MESSAGE_PREFIX="Auto-commit"   # Commit message prefix
CHECK_INTERVAL=1800                   # Time between checks (in seconds)

# === SCRIPT START ===
while true; do
    if pgrep -f "code" > /dev/null; then
        cd "$REPO_PATH" || {
            echo "❌ Repo path not found: $REPO_PATH"
            exit 1
        }

        if git status --porcelain | grep -q .; then
            TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
            COMMIT_MESSAGE="$COMMIT_MESSAGE_PREFIX: $TIMESTAMP"

            echo "📦 Changes detected. Committing..."
            git add -A
            git commit -m "$COMMIT_MESSAGE"
            git push origin "$BRANCH_NAME"
            echo "✅ Pushed to $BRANCH_NAME at $TIMESTAMP"
        else
            echo "🔍 No changes to commit."
        fi
    else
        echo "💤 VS Code not running. Skipping..."
    fi

    sleep "$CHECK_INTERVAL"
done
