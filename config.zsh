# THE SHADOW custom Zsh configuration
export TERM="xterm-256color"
setopt prompt_subst
autoload -Uz colors && colors

# Load the user's saved banner labels for the prompt
[[ -f "$HOME/.termux-shadow/settings" ]] && source "$HOME/.termux-shadow/settings"

# Load optional existing animation
if [[ -f "$HOME/loading.sh" ]]; then
  bash "$HOME/loading.sh"
fi

# Powerlevel10k instant prompt, if present
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load optional plugins if installed
[[ -f "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

if [[ -f "$HOME/.termux-shadow/banner.sh" ]]; then
  bash "$HOME/.termux-shadow/banner.sh"
fi

typeset -g DIR_ENTER_TIME=${DIR_ENTER_TIME:-$(date +%s)}
function chpwd() { DIR_ENTER_TIME=$(date +%s) }
function dir_time_spent() {
  local now=$(date +%s)
  local diff=$(( now - ${DIR_ENTER_TIME:-$now} ))
  printf "%02d:%02d" $((diff / 60)) $((diff % 60))
}
function short_path() {
  local p="$PWD"
  if [[ "$p" == "$HOME" ]]; then
    print -n "⌂"
  elif [[ "$p" == "$HOME/"* ]]; then
    print -n "⌂ » ${p#$HOME/}"
  else
    print -n "▸ $p"
  fi
}

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=always --group-directories-first'
  alias ll='eza -lah --icons=always --group-directories-first'
  alias la='eza -a --icons=always --group-directories-first'
  alias tree='eza --tree --icons=always'
else
  alias ls='ls --color=auto'
  alias ll='ls -lah --color=auto'
  alias la='ls -A --color=auto'
fi

PROMPT='%F{242}┌──(%F{196}☣ %F{196}${EXEC_WORD_1:-THE}~⚠~${EXEC_WORD_2:-SHADOW}_ %F{39}$(dir_time_spent)%F{242})──[%F{46}$(short_path)%F{242}]
%F{242}│ %F{196}⌛ %F{252}$(dir_time_spent)
%F{242}└─❯❯❯ %f'
