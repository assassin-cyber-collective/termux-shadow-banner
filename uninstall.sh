#!/data/data/com.termux/files/usr/bin/bash
set -eu

# Remove the shadow directory
rm -rf "$HOME/.termux-shadow"
echo 'Removed THE SHADOW files.'

# Clean the managed block from .zshrc and .bashrc
for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
    if [ -f "$rc" ]; then
        sed -i '/# >>> THE-SHADOW-MANAGED >>>/,/# <<< THE-SHADOW-MANAGED <<</d' "$rc" 2>/dev/null || true
        echo "Cleaned $rc"
    fi
done

# Optional: Remove the font if you want to revert to default
# rm -f "$HOME/.termux/font.ttf"
# termux-reload-settings

echo 'Uninstallation complete. You may need to restart Termux.'