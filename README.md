# THE SHADOW — Termux Banner

A red/cyan typography-focused Termux prompt setup. No background image and no hooded-person ASCII art.

## Install
Upload every file in this folder to the root of the public GitHub repository `assassin-cyber-collective/termux-shadow-banner`, on the `main` branch.

Run in Termux:
```bash
curl -fsSL https://raw.githubusercontent.com/assassin-cyber-collective/termux-shadow-banner/main/install.sh | bash
```

The installer asks for Name, Bio, Headline, and two Execute words before installing packages. It uses `/dev/tty` for interactive answers, then prints package/download progress. Existing shell startup files are backed up to `~/.termux-shadow-backups/` before `.zshrc` is configured.

## Icons
`eza` is installed for icons in `ls`, `ll`, `la`, and `tree`. Icon glyphs depend on the terminal font. If glyphs appear as boxes, choose a Nerd Font in Termux font settings; not every Android font contains Nerd Font icons.

## Files
- `install.sh` — interactive installer
- `config.zsh` — prompt, aliases, and startup config
- `banner.sh` — red/cyan title banner
- `uninstall.sh` — remove banner and restore `.zshrc` if backed up
