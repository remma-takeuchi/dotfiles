# ~/.config/shell/path.zsh

# Homebrew (Apple Silicon)
[[ -d /opt/homebrew/bin ]] && path=(/opt/homebrew/bin /opt/homebrew/sbin $path)

# Linuxbrew
[[ -d $HOME/.linuxbrew/bin ]] && path=($HOME/.linuxbrew/bin $HOME/.linuxbrew/sbin $path)

# user bin
[[ -d $HOME/.local/bin ]] && path=($HOME/.local/bin $path)

typeset -U path PATH  # 重複排除
export PATH
