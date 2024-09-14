# MACならパスを保管(dircolorsでエラーが出るため)
if [ "$(uname)" = 'Darwin' ]; then
    export PATH="$PATH:$(brew --prefix coreutils)/libexec/gnubin"
fi

# dircolors
eval `dircolors -b $HOME/.dircolors`

# cat
type bat > /dev/null 2>&1
if [ $? -eq 0 ] ; then
    alias cat="bat -pP"
fi

# vim
type nvim > /dev/null 2>&1
if [ $? -eq 0 ] ; then
    alias vim="nvim"
fi

# fzf
#export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

# fzf + rg
function fgr() {
  grep_cmd="grep --recursive --line-number --invert-match --regexp '^\s*$' * 2>/dev/null"
  if type "rg" >/dev/null 2>&1; then
    grep_cmd="rg --hidden --no-ignore --line-number --no-heading --invert-match '^\s*$' 2>/dev/null"
  fi
  read -r file line <<<"$(eval $grep_cmd | fzf --select-1 --exit-0 | awk -F: '{print $1, $2}')"
  ( [[ -z "$file" ]] || [[ -z "$line" ]] ) && return
  vim $file +$line
}

