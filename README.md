# THE SHADOW — Termux Banner (Fixed)

Mobile-friendly Zsh setup with a red/cyan banner, network status, personalized labels, directory timer, and Eza icons.

## Upload
Create a public repository named `termux-shadow-banner`, then upload all five files to the root:
`install.sh`, `config.zsh`, `banner.sh`, `uninstall.sh`, `README.md`.

In `install.sh`, replace `YOUR_GITHUB_USERNAME` with your GitHub username. Commit to `main`.

## One command
```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/termux-shadow-banner/main/install.sh | bash
```

The installer:
- Installs/checks packages and shows live status messages.
- Asks for Name, Bio, Headline, and two Execute words.
- Backs up existing `.bashrc`, `.zshrc`, `.bash_profile`, and `.profile` before changing startup config.
- Writes a clean `.zshrc` for this setup and attempts to set Zsh as the default shell.
- Leaves backups under `~/.termux-shadow-backups`.

## Notes
- A network connection is required.
- File icons use `eza`; a Nerd Font is recommended for the broadest icon coverage.
- Existing startup files are backed up, not deleted. This installer cannot safely identify and remove every third-party banner from every arbitrary shell file.
- Review the scripts before running them.

## Uninstall
```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/termux-shadow-banner/main/uninstall.sh | bash
```
