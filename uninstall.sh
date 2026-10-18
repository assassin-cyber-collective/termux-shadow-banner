#!/data/data/com.termux/files/usr/bin/bash
set -eu
BACKUP_DIR="$HOME/.termux-shadow-backups"
if [ -f "$BACKUP_DIR/zshrc.original" ]; then cp -p "$BACKUP_DIR/zshrc.original" "$HOME/.zshrc"; echo 'Restored original .zshrc'; else echo 'No original .zshrc backup with this legacy name; inspect timestamped backups before restoring.'; fi
rm -rf "$HOME/.termux-shadow"
echo 'Removed THE SHADOW files. Package installs and other backups were kept.'
