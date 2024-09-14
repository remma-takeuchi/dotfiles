# Key bind
bindkey -e
bindkey \^U backward-kill-line

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
plugins=(git sudo copypath copyfile z docker zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# Theme
source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
ZSH_THEME="powerlevel10k/powerlevel10k"
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# To be able to print japanease
setopt print_eight_bit
export LANG=en_US.UTF-8

# History
HIST_STAMPS="yyyy/mm/dd"
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

# ls
case "${OSTYPE}" in
darwin*)
    alias ls="ls -G"
    alias ll="ls -lG"
    alias la="ls -laG"
    export LSCOLORS=ExFxBxDxCxegedabagacad
    ;;
linux*)
    alias ls='ls --color'
    alias ll='ls -l --color'
    alias la='ls -la --color'
    #export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    ;;
esac
autoload -U compinit
compinit
export TERM=xterm-256color
export CLICOLOR=1
# zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
# zstyle ':completion:*' list-colors "${LS_COLORS}" # 補完候補のカラー表示


# Completion
# Case insensitive match
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# To be able to completion by pusshing tab
zstyle ':completion:*:default' menu select=1
#zstyle ':completion:*:default' menu select=2


# z - jump around
alias j=z

# fzf
#fzf --preview "bat  --color=always --style=header,grid --line-range :100 {}"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

# fzf + z
function fj() {
  dest=`z | gawk '{print $2}' | fzf --reverse --preview "tree -L 2 {}"`
  [ -z $dest ] && return 1
  cd $dest
}

# Macの場合はパスを通すため、先にローカル設定を読み込む
if [[ -e ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

if [[ -e ~/.config/shell/common_settings.sh ]]; then
  source ~/.config/shell/common_settings.sh
fi


