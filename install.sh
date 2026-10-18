#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
REPO_RAW="https://raw.githubusercontent.com/assassin-cyber-collective/termux-shadow-banner/main"
RED=$'\033[1;31m'; CYAN=$'\033[1;36m'; GREEN=$'\033[1;32m'; YELLOW=$'\033[1;33m'; RESET=$'\033[0m'

ok(){ printf '%s✓%s %s\n' "$GREEN" "$RESET" "$1"; }
info(){ printf '%s›%s %s\n' "$CYAN" "$RESET" "$1"; }
warn(){ printf '%s!%s %s\n' "$YELLOW" "$RESET" "$1"; }
fail(){ printf '%s✗%s %s\n' "$RED" "$RESET" "$1" >&2; exit 1; }

[ -n "${PREFIX:-}" ] && [ -x "$PREFIX/bin/pkg" ] || fail 'Run this installer inside Termux.'
clear 2>/dev/null || true

printf '%s╭──────────────────────────────────────────────╮%s\n' "$RED" "$RESET"
printf '%s│          THE SHADOW • TERMUX SETUP           │%s\n' "$CYAN" "$RESET"
printf '%s╰──────────────────────────────────────────────╯%s\n\n' "$RED" "$RESET"

# --- Customization Questions ---
ask(){ local prompt="$1" value=''; while true; do printf '%s%s%s ' "$CYAN" "$prompt" "$RESET" >/dev/tty; IFS= read -r value </dev/tty || fail 'Input error.'; value="${value#"${value%%[![:space:]]*}"}"; value="${value%"${value##*[![:space:]]}"}"; if [ -n "$value" ]; then printf '%s' "$value"; return; fi; printf '%sPlease enter a value.%s\n' "$YELLOW" "$RESET" >/dev/tty; done; }

printf '%sPersonalize your terminal%s\n' "$YELLOW" "$RESET"
NAME="$(ask 'Name for the big banner:')"
BIO1="$(ask 'Bio — line 1:')"
BIO2="$(ask 'Bio — line 2:')"
HEADLINE="$(ask 'Headline (replaces We aRe ThE MuSk):')"
EXEC1="$(ask 'Prompt first word (replaces THE):')"
EXEC2="$(ask 'Prompt second word (replaces SHADOW):')"

DEST="$HOME/.termux-shadow"; BACKUP="$HOME/.termux-shadow-backups/$(date +%Y%m%d-%H%M%S)"; mkdir -p "$DEST" "$BACKUP"

{ 
    printf 'BANNER_NAME=%q\n' "$NAME"; 
    printf 'BANNER_BIO1=%q\n' "$BIO1"; 
    printf 'BANNER_BIO2=%q\n' "$BIO2"; 
    printf 'BANNER_HEADLINE=%q\n' "$HEADLINE"; 
    printf 'PROMPT_WORD_1=%q\n' "$EXEC1"; 
    printf 'PROMPT_WORD_2=%q\n' "$EXEC2"; 
} > "$DEST/settings"
chmod 600 "$DEST/settings"; ok 'Personal settings saved'

# --- Auto Install Packages ---
printf '\n%sChecking and installing requirements%s\n' "$YELLOW" "$RESET"
pkg update -y >/dev/null 2>&1 || true
for pkg in curl zsh figlet eza git; do
    if ! command -v "$pkg" >/dev/null 2>&1; then
        info "Installing $pkg..."
        pkg install -y "$pkg" >/dev/null 2>&1 || fail "Could not install $pkg."
    fi
done
ok 'Packages installed.'

# --- Auto Nerd Font Installation ---
info 'Installing Nerd Font (JetBrainsMono)...'
mkdir -p "$HOME/.termux"
curl -fL --retry 2 "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf" -o "$HOME/.termux/font.ttf" >/dev/null 2>&1 || warn 'Font download failed.'
termux-reload-settings 2>/dev/null || true
ok 'Nerd Font installed.'

# --- Download Scripts ---
info 'Downloading scripts...'
for f in config.zsh banner.sh; do 
    curl -fL --retry 2 "$REPO_RAW/$f" -o "$DEST/$f" || fail "Download failed for $f."
done
chmod 700 "$DEST/banner.sh"
ok 'Scripts downloaded.'

# --- Backup & Fix Double Banner ---
for rc in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.profile"; do 
    if [ -f "$rc" ]; then cp -p "$rc" "$BACKUP/$(basename "$rc")"; fi
done

if [ -f "$HOME/.bashrc" ]; then
    sed -i '/# >>> THE-SHADOW-MANAGED >>>/,/# <<< THE-SHADOW-MANAGED <<</d' "$HOME/.bashrc"
    cat >> "$HOME/.bashrc" <<'BLOCK'

# >>> THE-SHADOW-MANAGED >>>
if [ -z "$ZSH_VERSION" ]; then
    [[ -f "$HOME/.termux-shadow/banner.sh" ]] && bash "$HOME/.termux-shadow/banner.sh"
fi
# <<< THE-SHADOW-MANAGED <<<
BLOCK
fi

ZRC="$HOME/.zshrc"
if [ -f "$ZRC" ]; then 
    sed -i '/# >>> THE-SHADOW-MANAGED >>>/,/# <<< THE-SHADOW-MANAGED <<</d' "$ZRC"
fi
cat >> "$ZRC" <<'BLOCK'

# >>> THE-SHADOW-MANAGED >>>
[[ -f "$HOME/.termux-shadow/config.zsh" ]] && source "$HOME/.termux-shadow/config.zsh"
# <<< THE-SHADOW-MANAGED <<<
BLOCK
ok '.zshrc and .bashrc updated.'

if [ "${SHELL##*/}" != zsh ]; then 
    chsh -s zsh >/dev/null 2>&1 || warn 'Run: chsh -s zsh manually.'
fi

printf '\n%sSetup complete!%s Starting Zsh...\n\n' "$GREEN" "$RESET"
exec zsh -l