# THE SHADOW — Termux personalized prompt

Keeps the user's original three-line Zsh prompt structure. Setup asks for banner name, two bio lines, headline, and the two prompt words that replace THE and SHADOW.

Upload all five files to the root of https://github.com/assassin-cyber-collective/termux-shadow-banner on the `main` branch.

Install:
```bash
curl -fsSL https://raw.githubusercontent.com/assassin-cyber-collective/termux-shadow-banner/main/install.sh | bash
```

File icons use `eza --icons=always`; icon glyphs require a Nerd Font supported by the selected Termux font. If icons show as boxes, select a Nerd Font in Termux:Style. Existing shell files are backed up to a timestamped directory under `~/.termux-shadow-backups/`. Review scripts before running them.
