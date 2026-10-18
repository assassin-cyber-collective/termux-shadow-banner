#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

REPO_URL="https://github.com/assassin-cyber-collective/termux-shadow-banner.git"
RED=$'\033[1;31m'; CYAN=$'\033[1;36m'; GREEN=$'\033[1;32m'; YELLOW=$'\033[1;33m'; RESET=$'\033[0m'

ok(){ printf '%s✔%s %s\n' "$GREEN" "$RESET" "$1"; }
info(){ printf '%s»%s %s\n' "$CYAN" "$RESET" "$1"; }
warn(){ printf '%s!%s %s\n' "$YELLOW" "$RESET" "$1"; }
fail(){ printf '%s✘%s %s\n' "$RED" "$RESET" "$1" >&2; exit 1; }

[ -n "${PREFIX:-}" ] && [ -x "$PREFIX/bin/pkg" ] || fail 'Run this installer inside Termux.'
clear 2>/dev/null || true

printf '%s╭──────────────────────────────────────────────╮%s\n' "$RED" "$RESET"
printf '%s│          THE SHADOW • TERMUX SETUP           │%s\n' "$CYAN" "$RESET"
printf '%s╰──────────────────────────────────────────────╯%s\n\n' "$RED" "$RESET"

# 1. Clean everything
info "Cleaning all previous installations..."
rm -rf "$HOME/.termux-shadow"
rm -rf "$HOME/termux-shadow-temp"
ok "Cleaned old directories"

# 2. Personalization
ask(){ local prompt="$1" value=''; while true; do printf '%s%s%s ' "$CYAN" "$prompt" "$RESET" >/dev/tty; IFS= read -r value </dev/tty || fail 'Could not read input.'; value="${value#"${value%%[![:space:]]*}"}"; value="${value%"${value##*[![:space:]]}"}"; if [ -n "$value" ]; then printf '%s' "$value"; return; fi; printf '%sPlease enter a value.%s\n' "$YELLOW" "$RESET" >/dev/tty; done; }

printf '%sPersonalize your terminal%s\n' "$YELLOW" "$RESET"
NAME="$(ask 'Name for the big banner:')"
BIO1="$(ask 'Bio — line 1:')"
BIO2="$(ask 'Bio — line 2:')"
HEADLINE="$(ask 'Headline (replaces We aRe ThE MuSk):')"
EXEC1="$(ask 'Prompt first word (replaces THE):')"
EXEC2="$(ask 'Prompt second word (replaces SHADOW):')"

DEST="$HOME/.termux-shadow"
mkdir -p "$DEST"
{ printf 'BANNER_NAME=%q\n' "$NAME"; printf 'BANNER_BIO1=%q\n' "$BIO1"; printf 'BANNER_BIO2=%q\n' "$BIO2"; printf 'BANNER_HEADLINE=%q\n' "$HEADLINE"; printf 'PROMPT_WORD_1=%q\n' "$EXEC1"; printf 'PROMPT_WORD_2=%q\n' "$EXEC2"; } > "$DEST/settings"
chmod 600 "$DEST/settings"
ok 'Personal settings saved'

# 3. Install Requirements
printf '\n%sChecking requirements%s\n' "$YELLOW" "$RESET"
pkg update -y >/dev/null 2>&1 || warn 'pkg update failed; proceeding anyway.'
install_package(){ local p="$1" c="$2"; if command -v "$c" >/dev/null 2>&1; then ok "$p installed"; else info "Installing $p..."; pkg install -y "$p" >/dev/null 2>&1 || fail "Could not install $p."; command -v "$c" >/dev/null 2>&1 || fail "$c missing."; ok "$p installed"; fi; }
install_package wget wget; install_package zsh zsh; install_package figlet figlet; install_package eza eza; install_package git git; install_package unzip unzip

# 4. Font Installation
info "Installing Nerd Font..."
mkdir -p "$HOME/.termux"
FONT_ZIP_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
if wget -q --timeout=20 --tries=3 "$FONT_ZIP_URL" -O "$HOME/.termux/Meslo.zip"; then
    unzip -o -j "$HOME/.termux/Meslo.zip" "MesloLGS*NerdFontMono-Regular.ttf" -d "$HOME/.termux/" >/dev/null 2>&1 || true
    EXTRACTED_FONT=$(find "$HOME/.termux" -maxdepth 1 -iname "*NerdFontMono-Regular.ttf" | head -n 1)
    if [ -n "$EXTRACTED_FONT" ]; then
        mv "$EXTRACTED_FONT" "$HOME/.termux/font.ttf"
        rm -f "$HOME/.termux/Meslo.zip"
        ok "Font installed."
        timeout 5 termux-reload-settings >/dev/null 2>&1 || true
        ok "Settings reloaded."
    else
        warn "Font extraction failed."
    fi
else
    warn "Font download failed."
fi

# 5. Download files
info "Fetching configuration files..."
git clone --depth 1 "$REPO_URL" "$HOME/termux-shadow-temp" >/dev/null 2>&1 || fail "Failed to download files."
cp "$HOME/termux-shadow-temp/config.zsh" "$DEST/config.zsh"
cp "$HOME/termux-shadow-temp/banner.sh" "$DEST/banner.sh"
chmod 700 "$DEST/banner.sh"
rm -rf "$HOME/termux-shadow-temp"
ok "Files downloaded."

# 6. FIX DOUBLE BANNER: Completely rewrite .zshrc safely
info "Rebuilding .zshrc cleanly..."
ZRC="$HOME/.zshrc"
# Backup existing .zshrc just in case
if [ -f "$ZRC" ]; then
    cp "$ZRC" "$HOME/.zshrc.bak_$(date +%s)"
fi
# Create a fresh .zshrc with ONLY our block
cat > "$ZRC" <<'BLOCK'
# >>> THE-SHADOW-MANAGED >>>
[[ -f "$HOME/.termux-shadow/config.zsh" ]] && source "$HOME/.termux-shadow/config.zsh"
# <<< THE-SHADOW-MANAGED <<<
BLOCK
ok '.zshrc cleaned and updated.'

# 7. Change shell
if [ "${SHELL##*/}" != zsh ]; then
    if command -v chsh >/dev/null 2>&1 && chsh -s zsh; then
        ok 'Default shell set to Zsh'
    else
        warn 'Could not switch automatically. Run: chsh -s zsh'
    fi
fi

printf '\n%sSetup complete! Starting Zsh...%s\n' "$GREEN" "$RESET"
exec zsh -l
