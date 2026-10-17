# THE SHADOW — Termux Banner

A customizable Termux Zsh theme inspired by a dark red/cyan terminal aesthetic.

## Included
- Personalized banner name, bio, headline, and two-word prompt label
- Network online/offline indicator
- Red/cyan text-art shadow figure beside the banner title
- Custom prompt with directory path and timer
- `eza` icons for files and folders (`ls`, `ll`, `la`, `tree`)
- Auto-check/install for required Termux packages
- Backup of existing `.zshrc`

## Upload to GitHub
1. Create a public repository named `termux-shadow-banner`.
2. Upload these files to the repository root: `install.sh`, `config.zsh`, `banner.sh`, `uninstall.sh`, `README.md`.
3. In `install.sh`, replace `YOUR_GITHUB_USERNAME` with your GitHub username.
4. Commit to the `main` branch.

## One-command setup
```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/termux-shadow-banner/main/install.sh | bash
```

The installer asks for:
1. Banner name
2. Bio
3. Headline
4. First execute word (replaces THE)
5. Second execute word (replaces SHADOW)

It checks/installs dependencies and shows a check mark for each available or installed package. Internet access is required for downloads and package installation.

## File icons
`eza` provides file/folder icons in directory listings. A Nerd Font-compatible terminal font is recommended for the broadest icon coverage. The hooded shadow is text art, not a photographic image, so its appearance may vary with terminal font and width.

## Uninstall
```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/termux-shadow-banner/main/uninstall.sh | bash
```

## Safety
Read scripts before running them. This setup does not upload your files or credentials. User-provided text is stored locally in `~/.termux-shadow/settings`.
