# ================================
# AutoGitPush PowerShell Script
# -------------------------------
# This script automatically commits and pushes changes to a Git repository 
# whenever Visual Studio Code is running, checking every 10 seconds.
# Branch used: SideBranch
# ================================

# Path to your local Git repository
$REPO_PATH = "S:\AUTOGITPUSH"

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
            $COMMIT_MESSAGE = "Auto-commit: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

            # Stage all changes (add new, modified, and deleted files)
            git add -A

            # Commit the staged changes
            git commit -m $COMMIT_MESSAGE

            # Push changes to the remote repository, targeting 'SideBranch'
            git push origin SideBranch

            # Output confirmation message with timestamp
            Write-Output "Changes pushed at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        } else {
            # Output message if there are no changes
            Write-Output "No changes to commit"
        }

    } else {
        # Output message if VS Code is not running
        Write-Output "VS Code not running, waiting..."
    }
    
    # Wait 10 seconds before checking again
    Start-Sleep -Seconds 10
}
