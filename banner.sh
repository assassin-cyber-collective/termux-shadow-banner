#!/data/data/com.termux/files/usr/bin/bash
set -u
[[ -f "$HOME/.termux-shadow/settings" ]] && source "$HOME/.termux-shadow/settings"

NAME="${BANNER_NAME:-MARK}"
BIO1="${BANNER_BIO1:-WE ARE THE GHOSTS BEHIND THE SCREEN}"
BIO2="${BANNER_BIO2:-SILENT, UNSEEN — BUT ALWAYS WATCHING}"
HEADLINE="${BANNER_HEADLINE:-We aRe ThE MuSk}"

# আপনার লোডিং অ্যানিমেশন
if [ -f "$HOME/loading.sh" ]; then
  bash "$HOME/loading.sh"
fi

# টপ বর্ডার
echo " < ━━━━━━━━━ [★] T E R M U X [★] ━━━━━━━━━━━━ > " | lolcat
echo
echo " $HEADLINE" | lolcat

# নেটওয়ার্ক স্ট্যাটাস
if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
  echo " ● Network Status: ONLINE (Internet Active)" | lolcat
else
  echo " ● Network Status: OFFLINE (TERMINAL IS IN OFFLINE MOOD)" | lolcat
fi

# ASCII ব্যানার (figlet)
echo
if command -v figlet >/dev/null 2>&1; then
  figlet "$NAME" | lolcat
else
  echo "$NAME" | lolcat
fi

# বায়ো ও বটম বর্ডার
echo
echo " $BIO1" | lolcat
echo " $BIO2" | lolcat
echo " < ━━━━━━━━━━━ [★]~~~~~~~~~~~~~~~~~~~~~~~~~[★] ━━━━━━━━━━━━ > " | lolcat
echo