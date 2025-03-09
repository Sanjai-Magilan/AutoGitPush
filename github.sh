#!/bin/bash

REPO_PATH="/home/zerotwo/Public/codings/"  # Change this to your GitHub repo path
COMMIT_MESSAGE="Auto-commit: $(date +'%Y-%m-%d %H:%M:%S')"

while true; do
    if pgrep -f "code" > /dev/null; then

        cd "$REPO_PATH" || exit
        if git diff --quiet; then
            echo "No changes to commit"
        else
            git add .
            git commit -m "$COMMIT_MESSAGE"
            git push origin main  # Change 'main' to your branch name if needed
            echo "Changes pushed at $(date)"       
        fi
        
    else
        echo "VS Code not running, waiting..."
    fi
    sleep 10 
done
