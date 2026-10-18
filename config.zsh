export TERM="xterm-256color"
setopt prompt_subst
autoload -Uz colors && colors
[[ -f "$HOME/.termux-shadow/settings" ]] && source "$HOME/.termux-shadow/settings"

#     
if [[ -f "$HOME/.termux-shadow/banner.sh" ]]; then 
    bash "$HOME/.termux-shadow/banner.sh"
fi

[[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]] && { export ZSH="$HOME/.oh-my-zsh"; ZSH_THEME=""; plugins=(git); source "$ZSH/oh-my-zsh.sh"; }
[[ -f "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

export DIR_ENTER_TIME=$(date +%s)
function chpwd() { export DIR_ENTER_TIME=$(date +%s) }
function dir_time_spent() { local now=$(date +%s); local diff=$(( now - ${DIR_ENTER_TIME:-$now} )); printf "%02d:%02d" $((diff/60)) $((diff%60)); }

short_path() { 
  local p=$(pwd); 
  if [ "$p" = "$HOME" ]; then echo ""; return; fi; 
  if [[ "$p" == "$HOME"* ]]; then 
    local sub="${p#$HOME/}"; 
    if [ -z "$sub" ]; then echo ""; else echo "»${sub##/}"; fi; 
    return; 
  fi; 
  echo "${p##/}"; 
}

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=always --group-directories-first'
  alias ll='eza -lah --icons=always --group-directories-first'
  alias la='eza -a --icons=always --group-directories-first'
  alias tree='eza --tree --icons=always'
fi

#     
PROMPT='%{%F{242}%}(%{%F{196}%} %{%F{196}%}${PROMPT_WORD_1:-THE}~~${PROMPT_WORD_2:-SHADOW}_%{%F{39}%}$(dir_time_spent)%{%F{242}%})[%{%F{46}%}$(short_path)%{%F{242}%}]
%{%F{242}%} %{%F{196}%}:- $(dir_time_spent)
%{%F{242}%}%{%F{196}%} %f '