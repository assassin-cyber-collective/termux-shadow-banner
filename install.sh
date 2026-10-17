#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

REPO="assassin-cyber-collective/termux-shadow-banner"
BRANCH="main"
RAW="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
APP="$HOME/.termux-shadow"
BACKUPS="$HOME/.termux-shadow-backups"
mkdir -p "$APP" "$BACKUPS"

R=$'\033[1;31m'; C=$'\033[1;36m'; G=$'\033[1;32m'; Y=$'\033[1;33m'; W=$'\033[1;37m'; D=$'\033[0;90m'; N=$'\033[0m'
ok(){ printf '%s  ✔ %s%s\n' "$G" "$1" "$N"; }
info(){ printf '%s  ◈ %s%s\n' "$C" "$1" "$N"; }
warn(){ printf '%s  ! %s%s\n' "$Y" "$1" "$N"; }
fail(){ printf '\n%s  ✖ %s%s\n' "$R" "$1" "$N" >&2; exit 1; }
trap 'rc=$?; printf "\n%s  ✖ Setup stopped (code %s). Scroll up for the error.%s\n" "$R" "$rc" "$N" >&2' ERR

[ -n "${PREFIX:-}" ] && [ -x "$PREFIX/bin/pkg" ] || fail "Open Termux and run this script inside Termux."
command -v curl >/dev/null 2>&1 || { printf '%scurl is required to bootstrap this installer.%s\n' "$Y" "$N"; pkg update -y; pkg install -y curl || fail "Could not install curl."; }

clear 2>/dev/null || true
printf '%s╭──────────────────────────────────────────────────────────╮%s\n' "$R" "$N"
printf '%s│%s  ◀━━━━━━━━━━ %sT E R M U X   /   T H E   S H A D O W%s ━━━━━━━━━▶  %s│%s\n' "$R" "$C" "$W" "$C" "$R" "$N"
printf '%s╰──────────────────────────────────────────────────────────╯%s\n\n' "$R" "$N"
printf '%s  PERSONALIZE YOUR TERMINAL%s\n\n' "$Y" "$N"

ask() {
  local prompt="$1" val=""
  while :; do
    printf '%s  › %s%s ' "$C" "$prompt" "$N" > /dev/tty
    IFS= read -r val < /dev/tty || fail "Cannot read input. Open an interactive Termux session."
    val="${val#"${val%%[![:space:]]*}"}"
    val="${val%"${val##*[![:space:]]}"}"
    if [ -n "$val" ]; then printf '%s' "$val"; return; fi
    printf '%s  Please enter a value.%s\n' "$Y" "$N" > /dev/tty
  done
}
NAME="$(ask 'Name for the large title:')"
BIO="$(ask 'Bio (one line):')"
HEADLINE="$(ask 'Headline:')"
WORD1="$(ask 'Execute word 1 (replaces THE):')"
WORD2="$(ask 'Execute word 2 (replaces SHADOW):')"

# Store arbitrary user text safely as shell-quoted values.
{
  printf 'BANNER_NAME=%q\n' "$NAME"
  printf 'BANNER_BIO=%q\n' "$BIO"
  printf 'BANNER_HEADLINE=%q\n' "$HEADLINE"
  printf 'EXEC_WORD_1=%q\n' "$WORD1"
  printf 'EXEC_WORD_2=%q\n' "$WORD2"
} > "$APP/settings"
chmod 600 "$APP/settings"
ok "Personalization saved"

printf '\n%s  CHECKING REQUIREMENTS%s\n' "$Y" "$N"
pkg update -y || warn "Package list refresh failed; checking installed packages anyway."

install_pkg() {
  local package="$1" bin="$2"
  if command -v "$bin" >/dev/null 2>&1; then ok "$package already installed"
  else
    info "Installing $package..."
    if pkg install -y "$package"; then ok "$package installed"; else fail "Install failed: $package. Check internet/repository settings."; fi
  fi
}
install_pkg curl curl
install_pkg git git
install_pkg zsh zsh
install_pkg figlet figlet
install_pkg eza eza
if ! command -v ping >/dev/null 2>&1; then
  if pkg install -y iputils; then ok "Network utility installed"; else warn "ping unavailable; network status will show unknown."; fi
else ok "Network utility already installed"; fi

if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
  info "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || fail "Oh My Zsh install failed."
  ok "Oh My Zsh installed"
else ok "Oh My Zsh already installed"; fi

# Download config files from this repository. This avoids assumptions about the clone folder.
for f in config.zsh banner.sh; do
  info "Downloading $f..."
  curl --fail --location --silent --show-error "$RAW/$f" -o "$APP/$f" || fail "Could not download $f from $RAW/$f. Ensure it exists in the repository root on branch $BRANCH."
  ok "$f ready"
done
chmod 700 "$APP/banner.sh"

# Back up all startup files once. Keep old files intact; do not destructively edit other setups.
for f in .bashrc .bash_profile .profile .zshrc; do
  if [ -f "$HOME/$f" ] && [ ! -f "$BACKUPS/$f.original" ]; then
    cp -p "$HOME/$f" "$BACKUPS/$f.original"
    ok "Backed up $f"
  fi
done

cat > "$HOME/.zshrc" <<'ZSHRC'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"
[[ -f "$HOME/.termux-shadow/config.zsh" ]] && source "$HOME/.termux-shadow/config.zsh"
ZSHRC
ok "Zsh startup configured"

if command -v chsh >/dev/null 2>&1; then
  if chsh -s zsh >/dev/null 2>&1; then ok "Default shell set to Zsh"; else warn "Could not change default shell automatically; run: chsh -s zsh"; fi
fi

printf '\n%s╭──────────────────────────────────────────╮%s\n' "$G" "$N"
printf '%s│  ✔ INSTALLATION COMPLETE                 │%s\n' "$G" "$N"
printf '%s╰──────────────────────────────────────────╯%s\n' "$G" "$N"
printf '  Backup location: %s\n' "$BACKUPS"
printf '  Starting Zsh...\n\n'
exec zsh -l
