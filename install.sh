#!/data/data/com.termux/files/usr/bin/bash
set -eu

REPO="YOUR_GITHUB_USERNAME/termux-shadow-banner"
BRANCH="main"
BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
DEST="$HOME/.termux-shadow"
TMP="$DEST/.download"

RED='\033[1;31m'; CYAN='\033[1;36m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; RESET='\033[0m'
ok()   { printf "${GREEN}  ✔${RESET} %s\n" "$1"; }
info() { printf "${CYAN}  …${RESET} %s\n" "$1"; }
fail() { printf "${RED}  ✘${RESET} %s\n" "$1"; }

clear
printf "${RED}╭──────────────────────────────────────────╮${RESET}\n"
printf "${RED}│       THE SHADOW  /  TERMUX SETUP         │${RESET}\n"
printf "${CYAN}╰──────────────────────────────────────────╯${RESET}\n\n"

if ! command -v pkg >/dev/null 2>&1; then
  fail "Termux package manager not found."
  exit 1
fi

mkdir -p "$DEST" "$TMP"

ask() {
  local prompt="$1" value=""
  while [ -z "$value" ]; do
    printf "${CYAN}%s${RESET} " "$prompt"
    IFS= read -r value || true
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    if [ -z "$value" ]; then
      printf "${YELLOW}Please enter a value.${RESET}\n"
    fi
  done
  printf '%s' "$value"
}

printf "${YELLOW}Personalize your terminal${RESET}\n"
NAME="$(ask 'Name for the big banner:')"
BIO="$(ask 'Bio (one line):')"
HEADLINE="$(ask 'Headline:')"
EXEC1="$(ask 'Execute text — first word (replaces THE):')"
EXEC2="$(ask 'Execute text — second word (replaces SHADOW):')"

# Store text as shell-escaped values without evaluating user input.
{
  printf 'BANNER_NAME=%q\n' "$NAME"
  printf 'BANNER_BIO=%q\n' "$BIO"
  printf 'BANNER_HEADLINE=%q\n' "$HEADLINE"
  printf 'EXEC_WORD_1=%q\n' "$EXEC1"
  printf 'EXEC_WORD_2=%q\n' "$EXEC2"
} > "$DEST/settings"

echo
printf "${YELLOW}Checking and installing requirements${RESET}\n"
pkg update -y >/dev/null 2>&1 || true

install_package() {
  pkgname="$1"
  command_name="$2"
  label="$3"
  if command -v "$command_name" >/dev/null 2>&1; then
    ok "$label already installed"
  else
    info "Installing $label..."
    if pkg install -y "$pkgname" >/dev/null 2>&1; then
      ok "$label installed"
    else
      fail "$label could not be installed automatically"
      return 1
    fi
  fi
}

install_package curl curl "curl"
install_package git git "Git"
install_package zsh zsh "Zsh"
install_package figlet figlet "Figlet"
install_package lolcat lolcat "Lolcat"
install_package eza eza "Eza (file icons)"
install_package iputils ping "Ping/network status"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh..."
  if RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >/dev/null 2>&1; then
    ok "Oh My Zsh installed"
  else
    fail "Oh My Zsh installation failed"
    exit 1
  fi
else
  ok "Oh My Zsh already installed"
fi

for file in config.zsh banner.sh; do
  info "Downloading $file..."
  if curl -fsSL "$BASE/$file" -o "$TMP/$file"; then
    ok "$file downloaded"
  else
    fail "Could not download $file. Check repository name and public access."
    exit 1
  fi
done

cp "$TMP/config.zsh" "$DEST/config.zsh"
cp "$TMP/banner.sh" "$DEST/banner.sh"
chmod 700 "$DEST/settings"
chmod +x "$DEST/banner.sh"

ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ] && [ ! -f "$HOME/.zshrc.shadow-backup" ]; then
  cp "$ZSHRC" "$HOME/.zshrc.shadow-backup"
  ok "Original .zshrc backed up"
fi

cat > "$ZSHRC" <<'ZSHRC_EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"
[ -f "$HOME/.termux-shadow/config.zsh" ] && source "$HOME/.termux-shadow/config.zsh"
ZSHRC_EOF
ok "Zsh configuration created"

rm -rf "$TMP"
echo
printf "${GREEN}✔ SETUP COMPLETE${RESET}\n"
printf "${CYAN}Restarting into Zsh...${RESET}\n"
exec zsh
