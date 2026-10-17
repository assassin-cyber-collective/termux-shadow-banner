export TERM="xterm-256color"
setopt prompt_subst
autoload -Uz colors && colors

[[ -f "$HOME/.termux-shadow/settings" ]] && source "$HOME/.termux-shadow/settings"

# Optional loading script from the user's existing setup.
[[ -f "$HOME/loading.sh" ]] && bash "$HOME/loading.sh"

# Optional Zsh plugins, if already present.
[[ -f "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

[[ -f "$HOME/.termux-shadow/banner.sh" ]] && bash "$HOME/.termux-shadow/banner.sh"

typeset -g DIR_ENTER_TIME=${DIR_ENTER_TIME:-$(date +%s)}
function chpwd() { DIR_ENTER_TIME=$(date +%s) }
function dir_time_spent() {
  local now=$(date +%s)
  local diff=$(( now - ${DIR_ENTER_TIME:-$now} ))
  printf "%02d:%02d" $((diff / 60)) $((diff % 60))
}
function short_path() {
  local p="$PWD"
  if [[ "$p" == "$HOME" ]]; then print -n "~"
  elif [[ "$p" == "$HOME/"* ]]; then print -n "~/${p#$HOME/}"
  else print -n "$p"
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

PROMPT='%F{196}╭─[☣ ${EXEC_WORD_1:-THE}~${EXEC_WORD_2:-SHADOW}] %F{39}$(date +%H:%M)%F{242} [%F{46}$(short_path)%F{242}]
%F{39}╰─❯❯❯ %f'
