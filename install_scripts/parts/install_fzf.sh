#!/bin/bash

type fzf > /dev/null
rc=$?
if [[ $rc -eq 0 ]]; then
  exit 0
fi

os_type=`uname`

# Debian
if [[ $os_type == "Linux" ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all --xdg --key-bindings --completion --update-rc --no-fish

# Mac
elif [[ $os_type == "Darwin" ]]; then
  brew install fzf
fi


