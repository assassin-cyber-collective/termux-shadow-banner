#!/data/data/com.termux/files/usr/bin/bash
set -u
[[ -f "$HOME/.termux-shadow/settings" ]] && source "$HOME/.termux-shadow/settings"

NAME="${BANNER_NAME:-MARK}"
BIO1="${BANNER_BIO1:-WE ARE THE GHOSTS BEHIND THE SCREEN}"
BIO2="${BANNER_BIO2:-SILENT, UNSEEN — BUT ALWAYS WATCHING}"
HEADLINE="${BANNER_HEADLINE:-We aRe ThE MuSk}"

RED=$'\033[1;31m'
CYAN=$'\033[1;36m'
GREEN=$'\033[1;32m'
GRAY=$'\033[0;90m'
RESET=$'\033[0m'

printf '\n%s < ━━━━━━━━━ [★] T E R M U X [★] ━━━━━━━━━━━━ > %s\n\n' "$CYAN" "$RESET"

printf '%s %s %s\n\n' "$RED" "$HEADLINE" "$RESET"

if command -v ping >/dev/null 2>&1 && ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then 
    printf ' %s●%s Network Status: \033[1;32mONLINE\033[0m %s(Internet Active)%s\n\n' "$GREEN" "$RESET" "$GRAY" "$RESET"
else 
    printf ' \033[1;31m●\033[0m Network Status: \033[1;31mOFFLINE\033[0m %s(Internet unavailable)%s\n\n' "$GRAY" "$RESET"
fi

# ASCII আর্ট (মাঝখানে আনার জন্য প্যাডিং সহ)
if command -v figlet >/dev/null 2>&1; then 
    FIGLET_OUTPUT=$(figlet -f slant -w 40 "$NAME" 2>/dev/null)
    if [ -n "$FIGLET_OUTPUT" ]; then
        while IFS= read -r line; do 
            printf '%s    %s    %s\n' "$RED" "$line" "$RESET"
        done <<< "$FIGLET_OUTPUT"
    else
        printf '%s    %s    %s\n' "$RED" "$NAME" "$RESET"
    fi
else 
    printf '%s    %s    %s\n' "$RED" "$NAME" "$RESET"
fi

printf '\n%s    %s%s\n' "$CYAN" "$BIO1" "$RESET"
printf '%s    %s%s\n' "$CYAN" "$BIO2" "$RESET"
printf '%s < ━━━━━━━━━━━ [★]~~~~~~~~~~~~~~~~~~~~~~~~~[★] ━━━━━━━━━━━━ > %s\n\n' "$GRAY" "$RESET"