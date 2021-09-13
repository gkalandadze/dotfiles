# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)
setopt COMPLETE_ALIASES
zstyle ':completion::complete:*' gain-privileges 1

# Fix Home,End,Delete keys
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char


# Add rehash hook
######################################################
zshcache_time="$(date +%s%N)"

autoload -Uz add-zsh-hook

rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}

add-zsh-hook -Uz precmd rehash_precmd
######################################################


# Syntax highlighting and autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Command not found handler, pkgfile package needed and run "pkgfile -u" first
# also enable pkgfile-update.timer
source /usr/share/doc/pkgfile/command-not-found.zsh


# History stuff
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY_TIME


# --- Uncomment these lines to enable sharing history between zsh sessions(disables saving duration of command to history) ---
# setopt SHARE_HISTORY
# bindkey "^[[A" up-line-or-local-history       # Arrow up (move through Local zsh session history)
# bindkey "^[[B" down-line-or-local-history     # Arrow down (move through Local zsh session history)
# bindkey "^[[1;5A" up-line-or-history          # [CTRL] + Arrow up (move through Global zsh history)
# bindkey "^[[1;5B" down-line-or-history        # [CTRL] + Arrow down (move through Global zsh history)
# up-line-or-local-history() {
#     zle set-local-history 1
#     zle up-line-or-history
#     zle set-local-history 0
# }
# zle -N up-line-or-local-history
# down-line-or-local-history() {
#     zle set-local-history 1
#     zle down-line-or-history
#     zle set-local-history 0
# }
# zle -N down-line-or-local-history


# Turn ctrl+z into toggle switch
ctrlz() {
  if [[ $#BUFFER == 0 ]]; then
    fg >/dev/null 2>&1 && zle redisplay
  else
    zle push-input
  fi
}
zle -N ctrlz
bindkey '^Z' ctrlz

# Use ranger to switch directories and bind it to ctrl-o
bindkey -s '^o' 'source ranger\n'


# Aliases
alias sudo='sudo '
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias grep='grep --colour=auto'
if [ -x "$(command -v exa)" ]; then
  alias ls='exa --group-directories-first'
  alias la='exa -a --group-directories-first'
  alias ll='exa -lg --group-directories-first --header --icons --git --color-scale'
  alias lla='exa -lag --group-directories-first --header --icons --git --color-scale'
  alias lt='exa -aT --group-directories-first --icons --git'
fi
alias cp='cp -iv'
alias mv='mv -i'
alias rm='rm -i'
alias pi='ssh gkala@192.168.1.250'
alias vaultwarden_sync='rsync -azcPv --delete gkala@192.168.1.250:/vw-data/backups/ /home/gkala/bitwarden/bitwarden_backup/'
alias history='history -iD 1'
if [ -x "$(command -v bat)" ]; then
  alias cat='bat -pp'
fi
alias c='clear'
# Interactive world map in terminal
alias mapscii='telnet mapscii.me'
# Get error messages from journalctl
alias jctl='journalctl -p 3 -xb'
# Benchmark zsh
alias zbench='for i in $(seq 1 10); do; time zsh -i -c exit; done'


# Source functions
[[ ! -f ~/.config/zsh/functions ]] || source ~/.config/zsh/functions


if [ -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]; then
  source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
