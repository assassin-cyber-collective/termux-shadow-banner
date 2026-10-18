#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
REPO_RAW="https://raw.githubusercontent.com/assassin-cyber-collective/termux-shadow-banner/main"
RED=$'\033[1;31m'; CYAN=$'\033[1;36m'; GREEN=$'\033[1;32m'; YELLOW=$'\033[1;33m'; RESET=$'\033[0m'
ok(){ printf '%s✔%s %s\n' "$GREEN" "$RESET" "$1"; }
info(){ printf '%s›%s %s\n' "$CYAN" "$RESET" "$1"; }
warn(){ printf '%s!%s %s\n' "$YELLOW" "$RESET" "$1"; }
fail(){ printf '%s✘%s %s\n' "$RED" "$RESET" "$1" >&2; exit 1; }
[ -n "${PREFIX:-}" ] && [ -x "$PREFIX/bin/pkg" ] || fail 'Run this installer inside Termux.'
clear 2>/dev/null || true
printf '%s╭──────────────────────────────────────────────╮%s\n' "$RED" "$RESET"
printf '%s│          THE SHADOW • TERMUX SETUP           │%s\n' "$CYAN" "$RESET"
printf '%s╰──────────────────────────────────────────────╯%s\n\n' "$RED" "$RESET"
ask(){ local prompt="$1" value=''; while true; do printf '%s%s%s ' "$CYAN" "$prompt" "$RESET" >/dev/tty; IFS= read -r value </dev/tty || fail 'Could not read terminal input.'; value="${value#"${value%%[![:space:]]*}"}"; value="${value%"${value##*[![:space:]]}"}"; if [ -n "$value" ]; then printf '%s' "$value"; return; fi; printf '%sPlease enter a value.%s\n' "$YELLOW" "$RESET" >/dev/tty; done; }
printf '%sPersonalize your terminal%s\n' "$YELLOW" "$RESET"
NAME="$(ask 'Name for the big banner:')"
BIO1="$(ask 'Bio — line 1:')"
BIO2="$(ask 'Bio — line 2:')"
HEADLINE="$(ask 'Headline (replaces We aRe ThE MuSk):')"
EXEC1="$(ask 'Prompt first word (replaces THE):')"
EXEC2="$(ask 'Prompt second word (replaces SHADOW):')"
DEST="$HOME/.termux-shadow"; BACKUP="$HOME/.termux-shadow-backups/$(date +%Y%m%d-%H%M%S)"; mkdir -p "$DEST" "$BACKUP"
{ printf 'BANNER_NAME=%q\n' "$NAME"; printf 'BANNER_BIO1=%q\n' "$BIO1"; printf 'BANNER_BIO2=%q\n' "$BIO2"; printf 'BANNER_HEADLINE=%q\n' "$HEADLINE"; printf 'PROMPT_WORD_1=%q\n' "$EXEC1"; printf 'PROMPT_WORD_2=%q\n' "$EXEC2"; } > "$DEST/settings"; chmod 600 "$DEST/settings"; ok 'Personal settings saved'
printf '\n%sChecking and installing requirements%s\n' "$YELLOW" "$RESET"
pkg update -y || warn 'pkg update failed; checking package installs anyway.'
install_package(){ local p="$1" c="$2"; if command -v "$c" >/dev/null 2>&1; then ok "$p already installed"; else info "Installing $p..."; pkg install -y "$p" || fail "Could not install $p. Check internet/repositories."; command -v "$c" >/dev/null 2>&1 || fail "$c still missing after installing $p"; ok "$p installed"; fi; }
install_package curl curl; install_package zsh zsh; install_package figlet figlet; install_package eza eza; install_package git git
warn 'File icons require a Nerd Font glyph set. Select a Nerd Font in Termux:Style if icons appear as boxes.'
for f in config.zsh banner.sh; do info "Downloading $f..."; curl -fL --retry 2 --connect-timeout 15 "$REPO_RAW/$f" -o "$DEST/$f" || fail "Download failed for $f. Ensure the file is at the repository root on main."; ok "$f downloaded"; done
chmod 700 "$DEST/banner.sh"
for rc in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.profile"; do if [ -f "$rc" ]; then cp -p "$rc" "$BACKUP/$(basename "$rc")"; ok "Backed up $(basename "$rc")"; fi; done
ZRC="$HOME/.zshrc"; if [ -f "$ZRC" ]; then sed '/# >>> THE-SHADOW-MANAGED >>>/,/# <<< THE-SHADOW-MANAGED <<</d' "$ZRC" > "$ZRC.tmp"; mv "$ZRC.tmp" "$ZRC"; fi
cat >> "$ZRC" <<'BLOCK'

# >>> THE-SHADOW-MANAGED >>>
[[ -f "$HOME/.termux-shadow/config.zsh" ]] && source "$HOME/.termux-shadow/config.zsh"
# <<< THE-SHADOW-MANAGED <<<
BLOCK
ok 'Updated .zshrc and preserved unrelated settings'
if [ "${SHELL##*/}" != zsh ]; then if command -v chsh >/dev/null 2>&1 && chsh -s zsh; then ok 'Default shell switched to Zsh'; else warn 'Could not switch automatically. Run: chsh -s zsh'; fi; fi
printf '\n%sSetup complete.%s Backup: %s\nStarting Zsh...\n' "$GREEN" "$RESET" "$BACKUP"
exec zsh -l
