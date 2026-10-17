#!/data/data/com.termux/files/usr/bin/bash
set -eu
if [ -f "$HOME/.zshrc.shadow-backup" ]; then
  cp "$HOME/.zshrc.shadow-backup" "$HOME/.zshrc"
  echo "✔ Restored ~/.zshrc from backup."
else
  echo "No backup found; ~/.zshrc left unchanged."
fi
rm -rf "$HOME/.termux-shadow"
echo "✔ Removed THE SHADOW banner files."
echo "Installed packages and Oh My Zsh were left installed."
