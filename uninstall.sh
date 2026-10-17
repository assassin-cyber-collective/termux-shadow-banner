#!/data/data/com.termux/files/usr/bin/bash
set -eu
APP="$HOME/.termux-shadow"
BACKUPS="$HOME/.termux-shadow-backups"
if [ -f "$BACKUPS/.zshrc.original" ]; then
  cp -p "$BACKUPS/.zshrc.original" "$HOME/.zshrc"
  echo "[✔] Restored original .zshrc"
else
  echo "[!] No original .zshrc backup found; current file left unchanged."
fi
rm -rf "$APP"
echo "[✔] Removed THE SHADOW banner files."
echo "Backups kept at: $BACKUPS"
echo "Installed packages and Oh My Zsh were not removed."
