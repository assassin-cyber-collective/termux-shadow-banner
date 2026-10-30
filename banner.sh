#!/data/data/com.termux/files/usr/bin/bash
set -u

[[ -f "$HOME/.termux-shadow/settings" ]] && source "$HOME/.termux-shadow/settings"

NAME="${BANNER_NAME:-MARK}"
BIO1="${BANNER_BIO1:-WE ARE THE GHOSTS BEHIND THE SCREEN}"
BIO2="${BANNER_BIO2:-SILENT, UNSEEN — BUT ALWAYS WATCHING}"
HEADLINE="${BANNER_HEADLINE:-We aRe ThE MuSk}"

# lolcat helper — lolcat না থাকলে plain print
lol() {
    if command -v lolcat >/dev/null 2>&1; then
        lolcat
    else
        cat
    fi
}

echo
echo " < ━━━━━━━━━ [★] T E R M U X [★] ━━━━━━━━━━━━ > " | lol
echo
echo " $HEADLINE" | lol

# ── Network Status ──
if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    echo " ● Network Status: ONLINE (Internet Active)" | lol
else
    echo " ● Network Status: OFFLINE (TERMINAL IS IN OFFLINE MOOD)" | lol
fi

# ── Big Name (lolcat) ──
if command -v figlet >/dev/null 2>&1; then
    figlet " $NAME" | lol
else
    echo " $NAME" | lol
fi

# ── Bio Lines + footer (অরজিনালের মতো একসাথে) ──
echo "
$BIO1
$BIO2
< ━━━━━━━━━━━ [★]~~~~~~~~~~~~~~~~~~~~~~~~~[★] ━━━━━━━━━━━━ > " | lol
