#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

REPO="assassin-cyber-collective/termux-shadow-banner"
BRANCH="main"
BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
DEST="$HOME/.termux-shadow"
BACKUP_DIR="$HOME/.termux-shadow-backups"
mkdir -p "$DEST" "$BACKUP_DIR"

RED=$'\033[1;31m'; CYAN=$'\033[1;36m'; GREEN=$'\033[1;32m'
YELLOW=$'\033[1;33m'; DIM=$'\033[0;90m'; RESET=$'\033[0m'
ok(){ printf '%s[✔]%s %s\n' "$GREEN" "$RESET" "$1"; }
step(){ printf '%s[ … ]%s %s\n' "$CYAN" "$RESET" "$1"; }
warn(){ printf '%s[! ]%s %s\n' "$YELLOW" "$RESET" "$1"; }
die(){ printf '%s[✘]%s %s\n' "$RED" "$RESET" "$1" >&2; exit 1; }

trap 'rc=$?; printf "\n%s[✘] Setup failed (exit %s). See message above.%s\n" "$RED" "$rc" "$RESET" >&2' ERR

clear 2>/dev/null || true
printf '%s╭────────────────────────────────────────────╮%s\n' "$RED" "$RESET"
printf '%s│       THE SHADOW  /  TERMUX INSTALLER       │%s\n' "$CYAN" "$RESET"
printf '%s╰────────────────────────────────────────────╯%s\n\n' "$RED" "$RESET"

[ -n "${PREFIX:-}" ] && [ -x "$PREFIX/bin/pkg" ] || die "Run this inside Termux."

# Install minimal tools before using them. Show live status; never hide all output.
step "Refreshing package lists..."
pkg update -y || warn "Package list update had a problem; continuing to check packages."

install_pkg() {
  local package="$1" command_name="$2"
  if command -v "$command_name" >/dev/null 2>&1; then
    ok "$package already installed"
  else
    step "Installing $package..."
    if pkg install -y "$package"; then
      ok "$package installed"
    else
      warn "$package installation failed. Check network/repository and retry."
      return 1
    fi
  fi
}
install_pkg curl curl
install_pkg git git
install_pkg zsh zsh
install_pkg figlet figlet
install_pkg eza eza
# lolcat is optional because package availability can vary
if ! command -v lolcat >/dev/null 2>&1; then
  step "Trying to install optional lolcat..."
  if pkg install -y lolcat; then ok "lolcat installed"; else warn "lolcat unavailable; banner works without it."; fi
else
  ok "lolcat already installed"
fi
if ! command -v ping >/dev/null 2>&1; then
  step "Installing network status utility..."
  if pkg install -y iputils; then ok "Network utility installed"; else warn "Network status may show unavailable without ping."; fi
else
  ok "Network utility already installed"
fi

# Oh My Zsh needed before the shell configuration is replaced.
if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
  step "Installing Oh My Zsh..."
  if ! command -v curl >/dev/null 2>&1; then die "curl is required to install Oh My Zsh."; fi
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || die "Oh My Zsh install failed."
  ok "Oh My Zsh installed"
else
  ok "Oh My Zsh already installed"
fi

# Ask for personalization before modifying startup configuration.
ask() {
  local prompt="$1" value=""
  while :; do
    printf '%s%s%s ' "$CYAN" "$prompt" "$RESET" > /dev/tty
    IFS= read -r value < /dev/tty || die "Could not read terminal input."
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    if [ -n "$value" ]; then printf '%s' "$value"; return 0; fi
    printf '%sPlease enter a value.%s\n' "$YELLOW" "$RESET" > /dev/tty
  done
}
printf '\n%sPersonalize your terminal%s\n' "$YELLOW" "$RESET"
NAME="$(ask 'Name for the big banner:')"
BIO="$(ask 'Bio (one line):')"
HEADLINE="$(ask 'Headline:')"
EXEC1="$(ask 'Execute — first word (replaces THE):')"
EXEC2="$(ask 'Execute — second word (replaces SHADOW):')"

# Safe shell quoting for arbitrary user text
{
  printf 'BANNER_NAME=%q\n' "$NAME"
  printf 'BANNER_BIO=%q\n' "$BIO"
  printf 'BANNER_HEADLINE=%q\n' "$HEADLINE"
  printf 'EXEC_WORD_1=%q\n' "$EXEC1"
  printf 'EXEC_WORD_2=%q\n' "$EXEC2"
} > "$DEST/settings"

# Download files with visible progress/status
for file in config.zsh banner.sh; do
  step "Downloading $file..."
  curl --fail --location --silent --show-error "$BASE/$file" -o "$DEST/$file" || die "Download failed for $file. Verify GitHub repo, branch, and files."
  ok "$file downloaded"
done
chmod 700 "$DEST/settings"
chmod 700 "$DEST/banner.sh"

# Back up current shell startup files, once per install
for rc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.bash_profile" "$HOME/.profile"; do
  if [ -f "$rc" ] && [ ! -f "$BACKUP_DIR/$(basename "$rc").original" ]; then
    cp -p "$rc" "$BACKUP_DIR/$(basename "$rc").original"
    ok "Backed up $(basename "$rc")"
  fi
done

# Remove older blocks from this project, then write clean zsh startup.
# Keep old files in backups rather than destructively deleting them.
cat > "$HOME/.zshrc" <<'ZSHRC_EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"
[[ -f "$HOME/.termux-shadow/config.zsh" ]] && source "$HOME/.termux-shadow/config.zsh"
ZSHRC_EOF
ok "Created clean ~/.zshrc"

# Switch default shell to Zsh if chsh is available; preserve backups.
if command -v chsh >/dev/null 2>&1; then
  if [ "${SHELL##*/}" != "zsh" ]; then
    step "Switching default shell to Zsh..."
    if chsh -s zsh; then ok "Default shell set to Zsh"; else warn "Could not change default shell automatically; run: chsh -s zsh"; fi
  else
    ok "Zsh is already the default shell"
  fi
fi

printf '\n%s[✔] INSTALLATION COMPLETE%s\n' "$GREEN" "$RESET"
printf '%sYour original startup files are backed up in:%s %s\n' "$DIM" "$RESET" "$BACKUP_DIR"
printf '%sStarting Zsh now...%s\n\n' "$CYAN" "$RESET"
exec zsh -l
