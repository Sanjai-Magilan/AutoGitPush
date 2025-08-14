# 🚀 AutoGitPush

AutoGitPush is a lightweight automation tool that commits and pushes your changes to a GitHub repository at regular intervals — perfect for developers who want to save work continuously without manual `git add`, `git commit`, and `git push`.

---

## ✨ Features
- ⏱ **Timed Commits** — Automatically commit changes every X minutes.
- 🖥 **Cross-Platform** — Works on Linux, macOS, and Windows (via PowerShell).
- 🔧 **Customizable** — Set commit messages and time intervals in seconds/minutes.
- 💻 **Lightweight** — Pure Shell/PowerShell script, no dependencies.
- 🛠 **CI/CD Friendly** — Integrates easily into DevOps workflows.

---

## 📦 Installation

### Linux / macOS
```bash
git clone https://github.com/Sanjai-Magilan/AutoGitPush.git
cd AutoGitPush/src
chmod +x autogitpush.sh
```

### Windows (PowerShell)
```powershell
git clone https://github.com/Sanjai-Magilan/AutoGitPush.git
cd AutoGitPush\src
```

---

## 🚀 Usage

### Linux / macOS
```bash
./autogitpush.sh
```

### Windows (PowerShell)
```powershell
.\autogitpush.ps1
```

---

## ⚙️ Configuration
You can edit the script variables to change:
- Commit interval (in seconds or minutes)
- Commit message template
- Target repository path

Example (inside `autogitpush.sh`):
```bash
INTERVAL=1800    # 30 minutes
MESSAGE="Auto commit at $(date)"
```

---

## 📂 Project Structure
```
AutoGitPush/
│── src/                  # Shell & PowerShell scripts
│── examples/             # Example screenshots
│── README.md
│── LICENSE
│── CONTRIBUTING.md
│── CHANGELOG.md
```

---

## 🛠 Contributing
We welcome contributions!  
Check the [CONTRIBUTING.md](CONTRIBUTING.md) for detailed instructions.

---

## 📜 License
This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 🌟 Star This Repo
If you like this project, please **star** ⭐ it on GitHub — it really helps!

---
