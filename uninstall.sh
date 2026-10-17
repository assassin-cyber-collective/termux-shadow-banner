#!/data/data/com.termux/files/usr/bin/bash
set -eu
BACKUP_DIR="$HOME/.termux-shadow-backups"
if [ -f "$BACKUP_DIR/zshrc.original" ]; then
  cp -p "$BACKUP_DIR/zshrc.original" "$HOME/.zshrc"
  echo "[✔] Restored original ~/.zshrc"
else
  echo "[!] No original .zshrc backup found; left it unchanged."
fi
if [ -f "$BACKUP_DIR/bashrc.original" ]; then
  cp -p "$BACKUP_DIR/bashrc.original" "$HOME/.bashrc"
  echo "[✔] Original ~/.bashrc backup is available at $BACKUP_DIR/bashrc.original"
fi
rm -rf "$HOME/.termux-shadow"
echo "[✔] Removed THE SHADOW banner files."
echo "[i] Packages and Oh My Zsh were not removed."
echo "[i] Restart Termux to apply changes."
