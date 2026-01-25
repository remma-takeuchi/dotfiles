# MACならパスを保管(dircolorsでエラーが出るため)
if [ "$(uname)" = 'Darwin' ]; then
  export PATH="$PATH:$(brew --prefix coreutils)/libexec/gnubin"
fi

# # dircolors
# eval `dircolors -b $HOME/.dircolors`

# cat
type bat >/dev/null 2>&1
if [ $? -eq 0 ]; then
  alias cat="bat -pP"
fi

# vim
type nvim >/dev/null 2>&1
if [ $? -eq 0 ]; then
  alias vim="nvim"
fi

# fzf
# 基本設定
eval "$($(brew --prefix)/bin/brew shellenv)"
FZF_PATH=$(brew --prefix fzf)
source $FZF_PATH/shell/key-bindings.zsh
source $FZF_PATH/shell/completion.zsh 2>/dev/null

# FZFコマンドコンフィグ
source $HOME/.config/fzf/config
