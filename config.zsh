export TERM="xterm-256color"
setopt prompt_subst

[[ -f "$HOME/.termux-shadow/settings" ]] && source "$HOME/.termux-shadow/settings"

#    
[[ -f "$HOME/.termux-shadow/banner.sh" ]] && bash "$HOME/.termux-shadow/banner.sh"

# Oh My Zsh 
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME=""
plugins=(git)
source $ZSH/oh-my-zsh.sh
source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

function chpwd() {
export DIR_ENTER_TIME=$(date +%s)
}
export DIR_ENTER_TIME=$(date +%s)

function dir_time_spent() {
local now=$(date +%s)
local diff=$(( now - ${DIR_ENTER_TIME:-$now} ))
printf "%02d:%02d" $((diff/60)) $((diff%60))
}

short_path() {
local p=$(pwd)
if [ "$p" = "$HOME" ]; then
echo ""
return
fi
if [[ "$p" == "$HOME"* ]]; then
local sub="${p#$HOME/}"
if [ -z "$sub" ]; then
echo ""
else
echo "»${sub##/}"
fi
return
fi
echo "${p##/}"
}

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=always --group-directories-first'
  alias ll='eza -lah --icons=always --group-directories-first'
  alias la='eza -a --icons=always --group-directories-first'
  alias tree='eza --tree --icons=always'
fi

#    (% )
PROMPT='%{%F{242}%}(%{%F{196}%} %{%F{196}%}THE~~SHADOW_%{%F{39}%}$(dir_time_spent)%{%F{242}%})[%{%F{46}%}$(short_path)%{%F{242}%}]
%{%F{242}%} %{%F{196}%}:- $(dir_time_spent)
%{%F{242}%} %f '