# ~/.config/shell/path.zsh

# Homebrew (Apple Silicon)
[[ -d /opt/homebrew/bin ]] && path=(/opt/homebrew/bin /opt/homebrew/sbin /opt/homebrew/opt/openjdk/bin $path)

# Linuxbrew
TARGET_PATH="/home/linuxbrew/.linuxbrew/"
[[ -d $TARGET_PATH/bin ]] && path=($TARGET_PATH/bin $TARGET_PATH/sbin $path)

# user bin
TARGET_PATH="$HOME/.local/bin"
[[ -d $TARGET_PATH ]] && path=($path $TARGET_PATH)

typeset -U path PATH  # 重複排除
export PATH

# pyenv (shimsをPATH先頭に置き、Homebrew等のpython3より優先させる)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && path=($PYENV_ROOT/bin $path)
typeset -U path PATH
export PATH
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export PATH="$(npm config get prefix)/bin:$PATH"
