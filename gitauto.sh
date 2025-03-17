#!/bin/bash

REPO_PATH="/home/zerotwo/Public/weapons/"  
COMMIT_MESSAGE="Auto-commit: $(date +'%Y-%m-%d %H:%M:%S')"

while true; do
    if pgrep -f "code" > /dev/null; then
        cd "$REPO_PATH" || exit
        if git status --porcelain | grep -q .; then
            git add -A 
            git commit -m "$COMMIT_MESSAGE"
            git push origin main    
        else
        fi
    else  
    fi
    sleep 1800
done
