# ~/.config/shell/path.zsh

# Homebrew (Apple Silicon)
[[ -d /opt/homebrew/bin ]] && path=(/opt/homebrew/bin /opt/homebrew/sbin $path)

# Linuxbrew
TARGET_PATH="/home/linuxbrew/.linuxbrew/"
[[ -d $TARGET_PATH/bin ]] && path=($TARGET_PATH/bin $TARGET_PATH/sbin $path)

# user bin
TARGET_PATH="$HOME/.local/bin"
[[ -d $TARGET_PATH ]] && path=($TARGET_PATH $path)

typeset -U path PATH  # 重複排除
export PATH
