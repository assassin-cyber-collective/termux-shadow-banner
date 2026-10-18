export TERM="xterm-256color"
setopt prompt_subst
autoload -Uz colors && colors

# Prevent duplicate loading
if [[ -z "${SHADOW_LOADED:-}" ]]; then
    export SHADOW_LOADED=1
    
    [[ -f "$HOME/.termux-shadow/settings" ]] && source "$HOME/.termux-shadow/settings"
    if [[ -f "$HOME/loading.sh" ]]; then bash "$HOME/loading.sh"; fi
    [[ -f "$HOME/.termux-shadow/banner.sh" ]] && bash "$HOME/.termux-shadow/banner.sh"
    
    [[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]] && { export ZSH="$HOME/.oh-my-zsh"; ZSH_THEME=""; plugins=(git); source "$ZSH/oh-my-zsh.sh"; }
    [[ -f "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [[ -f "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

export DIR_ENTER_TIME=$(date +%s)
function chpwd() { export DIR_ENTER_TIME=$(date +%s) }
function dir_time_spent() { local now=$(date +%s); local diff=$(( now - ${DIR_ENTER_TIME:-$now} )); printf "%02d:%02d" $((diff/60)) $((diff%60)); }
short_path() { local p=$(pwd); if [ "$p" = "$HOME" ]; then echo "⌂"; return; fi; if [[ "$p" == "$HOME"* ]]; then local sub="${p#$HOME/}"; if [ -z "$sub" ]; then echo "⌂"; else echo "⌂»📂${sub##/}"; fi; return; fi; echo "📂${p##/}"; }

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=always --group-directories-first'
  alias ll='eza -lah --icons=always --group-directories-first'
  alias la='eza -a --icons=always --group-directories-first'
  alias tree='eza --tree --icons=always'
fi

# Rainbow Generator Function for Banner
function print_rainbow() {
    local text="$1"
    local colors=("\033[1;31m" "\033[1;33m" "\033[1;32m" "\033[1;36m" "\033[1;34m" "\033[1;35m")
    local text_len=${#text}
    for (( i=0; i<$text_len; i++ )); do
        local char="${text:$i:1}"
        local c_idx=$(( (i + $(date +%N | cut -c1-3)) % ${#colors[@]} ))
        printf "${colors[$c_idx]}%s" "$char"
    done
    printf "\033[0m\n"
}

# Save the rainbow function so banner.sh can use it
export -f print_rainbow 2>/dev/null || true

PROMPT='%{%F{242}%}┌──(%{%F{196}%}☣ %{%F{196}%}${PROMPT_WORD_1:-THE}~⚠~${PROMPT_WORD_2:-SHADOW}_%{%F{39}%}$(dir_time_spent)%{%F{242}%})──[%{%F{46}%}$(short_path)%{%F{242}%}]
%{%F{242}%}│ %{%F{196}%}⏳:- $(dir_time_spent)
%{%F{242}%}└─❯❯❯ %f '
