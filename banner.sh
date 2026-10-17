#!/data/data/com.termux/files/usr/bin/bash
set -u
SETTINGS="$HOME/.termux-shadow/settings"
[ -f "$SETTINGS" ] && source "$SETTINGS"

NAME="${BANNER_NAME:-MARK}"
BIO="${BANNER_BIO:-WE ARE THE GHOSTS BEHIND THE SCREEN — SILENT, UNSEEN, BUT ALWAYS WATCHING}"
HEADLINE="${BANNER_HEADLINE:-We aRe ThE MuSk}"
EXEC1="${EXEC_WORD_1:-THE}"
EXEC2="${EXEC_WORD_2:-SHADOW}"

RED=$'\033[1;31m'; CYAN=$'\033[1;36m'; GREEN=$'\033[1;32m'
DIM=$'\033[0;90m'; WHITE=$'\033[1;37m'; RESET=$'\033[0m'

clear
printf '%s╭──────────────────────────────────────────────────────╮%s\n' "$RED" "$RESET"
printf '%s│  ◀━━━━━━━━━━━━━━  [✦]  T E R M U X  [✦]  ━━━━━━━━━▶ │%s\n' "$CYAN" "$RESET"
printf '%s╰──────────────────────────────────────────────────────╯%s\n\n' "$RED" "$RESET"

printf '%s  %s%s\n\n' "$RED" "$HEADLINE" "$RESET"

if command -v ping >/dev/null 2>&1 && ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
  printf '  %s●%s Network Status: %sONLINE%s %s(Internet active)%s\n\n' "$GREEN" "$RESET" "$GREEN" "$RESET" "$DIM" "$RESET"
else
  printf '  %s●%s Network Status: %sOFFLINE%s %s(No connection detected)%s\n\n' "$RED" "$RESET" "$RED" "$RESET" "$DIM" "$RESET"
fi

# Compact text-art shadow silhouette, safe for standard terminal fonts.
printf '%s       ░▒▓████▓▒░%s\n' "$RED" "$RESET"
printf '%s      ░▓█%s▒░  ░▒%s█▓░%s\n' "$RED" "$DIM" "$RED" "$RESET"
printf '%s     ░▓█%s  ◥██◤  %s█▓░%s      %s' "$RED" "$DIM" "$RED" "$RESET" "$WHITE"
if command -v figlet >/dev/null 2>&1; then
  figlet -w 30 -f standard "$NAME" 2>/dev/null | head -n 4
else
  printf '%s\n' "$NAME"
fi
printf '%s    ░▓█%s  ▄████▄  %s█▓░%s\n' "$RED" "$DIM" "$RED" "$RESET"
printf '%s   ░▓█%s ▄████████▄ %s█▓░%s\n' "$RED" "$DIM" "$RED" "$RESET"
printf '%s  ░▒▓██████████████▓▒░%s\n\n' "$DIM" "$RESET"

printf '%s  %s%s\n' "$CYAN" "$BIO" "$RESET"
printf '%s  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%s\n' "$DIM" "$RESET"
printf '%s  [✦] %s  %s [✦]%s\n' "$CYAN" "$EXEC1" "$EXEC2" "$RESET"
printf '%s  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%s\n\n' "$DIM" "$RESET"
