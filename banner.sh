#!/data/data/com.termux/files/usr/bin/bash
set -u

SETTINGS="$HOME/.termux-shadow/settings"
[ -f "$SETTINGS" ] && source "$SETTINGS"

NAME="${BANNER_NAME:-MARK}"
BIO="${BANNER_BIO:-WE ARE THE GHOSTS BEHIND THE SCREEN; SILENT, UNSEEN — BUT ALWAYS WATCHING}"
HEADLINE="${BANNER_HEADLINE:-We aRe ThE MuSk}"
EXEC1="${EXEC_WORD_1:-THE}"
EXEC2="${EXEC_WORD_2:-SHADOW}"

RED='\033[1;31m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
DIM='\033[0;90m'
WHITE='\033[1;37m'
RESET='\033[0m'

clear
printf "${DIM}╭──────────────────────────────────────────────────────────╮${RESET}\n"
printf "${CYAN}│  ◀━━━━━━━━━━━━━━  [✦]  T E R M U X  [✦]  ━━━━━━━━━━━▶${RESET}\n"
printf "${DIM}╰──────────────────────────────────────────────────────────╯${RESET}\n\n"

printf "${RED}  %s${RESET}\n\n" "$HEADLINE"

if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
  printf "  ${GREEN}●${RESET} ${WHITE}Network Status:${RESET} ${GREEN}ONLINE${RESET} ${DIM}(Internet active)${RESET}\n\n"
else
  printf "  ${RED}●${RESET} ${WHITE}Network Status:${RESET} ${RED}OFFLINE${RESET} ${DIM}(No connection detected)${RESET}\n\n"
fi

# Stylized terminal shadow figure built from text, no external image needed.
printf "${RED}       ░▒▓████▓▒░${CYAN}                    "
if command -v figlet >/dev/null 2>&1; then
  figlet -w 48 -f standard "$NAME" 2>/dev/null | head -n 5 | while IFS= read -r line; do
    printf "${WHITE}%s${RESET}\n" "$line"
  done
else
  printf "${WHITE}  %s${RESET}\n" "$NAME"
fi
printf "${RED}      ░▓█${DIM}▒░  ░▒${RED}█▓░${RESET}\n"
printf "${RED}     ░▓█${DIM}  ◥██◤  ${RED}█▓░${RESET}\n"
printf "${RED}    ░▓█${DIM}  ▄████▄  ${RED}█▓░${RESET}\n"
printf "${RED}   ░▓█${DIM} ▄████████▄ ${RED}█▓░${RESET}\n"
printf "${DIM}  ░▒▓██████████████▓▒░${RESET}\n"

printf "\n${CYAN}  %s${RESET}\n" "$BIO"
printf "${DIM}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "${CYAN}  [✦] %s  %s [✦]${RESET}\n" "$EXEC1" "$EXEC2"
printf "${DIM}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n\n"
