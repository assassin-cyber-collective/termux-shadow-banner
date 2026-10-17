#!/data/data/com.termux/files/usr/bin/bash
set -u
[ -f "$HOME/.termux-shadow/settings" ] && source "$HOME/.termux-shadow/settings"
NAME="${BANNER_NAME:-THE SHADOW}"
BIO="${BANNER_BIO:-We are the ghosts behind the screen; silent, unseen but always watching}"
HEADLINE="${BANNER_HEADLINE:-CYBERSPACE IS OUR TERRITORY}"
R=$'\033[1;31m'; C=$'\033[1;36m'; G=$'\033[1;32m'; W=$'\033[1;37m'; D=$'\033[0;90m'; N=$'\033[0m'
clear 2>/dev/null || true

printf '%s╭──────────────────────────────────────────────────╮%s\n' "$R" "$N"
printf '%s│%s  ◀━━━━━━━━━━ %s[✦]  T E R M U X  [✦]%s ━━━━━━━━━▶  %s│%s\n' "$R" "$C" "$W" "$C" "$R" "$N"
printf '%s╰──────────────────────────────────────────────────╯%s\n\n' "$R" "$N"

printf '%s  %s%s\n\n' "$R" "$HEADLINE" "$N"
if command -v ping >/dev/null 2>&1; then
  if ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1; then
    printf '  %s●%s Network Status: %sONLINE%s %s(Internet active)%s\n\n' "$G" "$N" "$G" "$N" "$D" "$N"
  else
    printf '  %s●%s Network Status: %sOFFLINE%s %s(Connection not detected)%s\n\n' "$R" "$N" "$R" "$N" "$D" "$N"
  fi
else
  printf '  %s●%s Network Status: %sUNKNOWN%s %s(ping not installed)%s\n\n' "$D" "$N" "$D" "$N" "$D" "$N"
fi

# Typography-only banner: no external image and no large hooded-person ASCII art.
if command -v figlet >/dev/null 2>&1; then
  figlet -w 42 -f small "$NAME" 2>/dev/null | head -n 5 | while IFS= read -r line; do printf '%s%s%s\n' "$R" "$line" "$N"; done
else
  printf '%s  ╔══ %s ══╗%s\n' "$R" "$NAME" "$N"
fi
printf '\n%s  %s%s\n' "$C" "$BIO" "$N"
printf '%s  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%s\n' "$D" "$N"
printf '%s  [✦] %s  /  %s [✦]%s\n' "$C" "${EXEC_WORD_1:-THE}" "${EXEC_WORD_2:-SHADOW}" "$N"
printf '%s  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%s\n\n' "$D" "$N"
