#!/data/data/com.termux/files/usr/bin/bash
set -u
[[ -f "$HOME/.termux-shadow/settings" ]] && source "$HOME/.termux-shadow/settings"

NAME="${BANNER_NAME:-MARK}"; 
BIO1="${BANNER_BIO1:-WE ARE THE GHOSTS BEHIND THE SCREEN}"; 
BIO2="${BANNER_BIO2:-SILENT, UNSEEN — BUT ALWAYS WATCHING}"; 
HEADLINE="${BANNER_HEADLINE:-We aRe ThE MuSk}"

RED=$'\033[1;31m'; CYAN=$'\033[1;36m'; GREEN=$'\033[1;32m'; GRAY=$'\033[0;90m'; RESET=$'\033[0m'

COLS=$(tput cols)
if [ "$COLS" -gt 80 ]; then COLS=80; fi

center_text() {
    local text="$1"
    local len=${#text}
    local padding=$(( (COLS - len) / 2 ))
    if [ "$padding" -gt 0 ]; then printf "%${padding}s" ""; fi
    printf "%s\n" "$text"
}

clear
echo ""
printf '%s' "$CYAN"; center_text "━━━━━━━━━━━━━━━[ ★ ]━━━━━━━━━━━━━━━"; printf '%s' "$RESET"
printf '%s' "$RED"; center_text "$HEADLINE"; printf '%s' "$RESET"
echo ""

if command -v ping >/dev/null 2>&1 && ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then 
    printf '%s' " ● Network Status: "; printf '\033[1;32mONLINE\033[0m %s(Internet Active)%s\n\n' "$GRAY" "$RESET"
else 
    printf '%s' " ● Network Status: "; printf '\033[1;31mOFFLINE\033[0m %s(Internet unavailable)%s\n\n' "$GRAY" "$RESET"
fi

# Figlet ASCII আর্ট (মাঝখানে)
if command -v figlet >/dev/null 2>&1; then 
    figlet -w "$COLS" -c -f big "$NAME" 2>/dev/null | while IFS= read -r line; do 
        printf '%s%s%s\n' "$RED" "$line" "$RESET"
    done
else 
    printf '%s' "$RED"; center_text "$NAME"; printf '%s' "$RESET"
fi

echo ""
printf '%s' "$CYAN"; center_text "$BIO1"; printf '%s' "$RESET"
printf '%s' "$CYAN"; center_text "$BIO2"; printf '%s' "$RESET"
printf '%s' "$GRAY"; center_text "━━━━━━━━━━━━[ ★ ]━━━━━━━━━━━━"; printf '%s' "$RESET"
echo ""