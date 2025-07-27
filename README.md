# AutoGitPush ⏱️🚀

A lightweight automation toolkit to help developers auto-commit and auto-push their code changes to GitHub **every 30 minutes** using Shell and PowerShell scripts.

## 🧩 Features

- Automatically commits changes in your Git project every 30 minutes.
- Pushes updates to the configured remote branch without user input.
- Supports both Unix-based systems (`gitauto.sh`) and Windows (`github.ps1`).
- Helpful for regular version backups and long coding sessions.

## 📁 Files

- `gitauto.sh` — Bash script for Linux/macOS automation.
- `github.ps1` — PowerShell script for Windows users.

## ⏰ How It Works

Once started, the script:

1. Monitors your working directory.
2. Every 30 minutes, it:
   - Stages all changes.
   - Commits them with a timestamp message.
   - Pushes them to your remote GitHub repository.

> Works best for solo projects, journals, or continuous coding backups.

## 🚀 Getting Started

### On Linux/macOS

```bash
chmod +x gitauto.sh
./gitauto.sh
```

### On Windows PowerShell

```powershell
.\github.ps1
```

> ⚠️ Ensure your Git repo is initialized and a remote is set (e.g., `origin`).

## 🛠 Requirements

- Git must be installed and configured.
- Your terminal must have access to your GitHub repo (via HTTPS or SSH).
- Ensure Git credentials are cached or SSH key is active.

## 📌 Use Case

Perfect for:

- Auto-saving classwork or coding exercises.
- Frequent commits for long development sessions.
- Preventing "forgot to commit" scenarios.
- Projects that require continuous syncing without manual effort.

## 🤝 Contributing

Pull requests are welcome! Feel free to fork the repo and submit enhancements.
