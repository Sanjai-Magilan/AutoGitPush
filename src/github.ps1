$REPO_PATH = "C:\path\to\your\git\repo"  
$COMMIT_MESSAGE = "Auto-commit: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

while ($true) {
    if (Get-Process | Where-Object { $_.ProcessName -like "Code*" }) {

        Set-Location -Path $REPO_PATH

        if (-not ([string]::IsNullOrWhiteSpace((git status --porcelain)))) {
            git add -A
            git commit -m $COMMIT_MESSAGE
            git push origin main
            Write-Output "Changes pushed at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        } else {
            Write-Output "No changes to commit"
        }

    } else {
        Write-Output "VS Code not running, waiting..."
    }
    
    Start-Sleep -Seconds 1800
}
