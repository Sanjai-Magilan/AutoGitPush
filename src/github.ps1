$REPO_PATH = "S:\AUTOGITPUSH"

while ($true) {
    if (Get-Process | Where-Object { $_.ProcessName -like "Code*" }) {

        Set-Location -Path $REPO_PATH

        if (-not ([string]::IsNullOrWhiteSpace((git status --porcelain)))) {
            $COMMIT_MESSAGE = "Auto-commit: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            git add -A
            git commit -m $COMMIT_MESSAGE
            git push origin SideBranch
            Write-Output "Changes pushed at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        } else {
            Write-Output "No changes to commit"
        }

    } else {
        Write-Output "VS Code not running, waiting..."
    }
    
    Start-Sleep -Seconds 180
}
