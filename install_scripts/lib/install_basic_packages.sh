#!/bin/bash

os_type=`uname`

if [[ $os_type == "Linux" ]]; then
  type sudo > /dev/null 2>&1
  rc=$?
  if [ $rc != 0 ] ; then
    apt update && apt install sudo
  fi
  sudo apt update
  DEBIAN_FRONTEND=noninteractive sudo apt install -y git wget curl
  DEBIAN_FRONTEND=noninteractive sudo apt install -y zsh tmux
  DEBIAN_FRONTEND=noninteractive sudo apt install -y python3 python3-pip
  DEBIAN_FRONTEND=noninteractive sudo apt install -y python3 python3-pip

  # FZF
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install

elif [[ $os_type == "Darwin" ]]; then
  brew install fzf
fi

pip3 install pynvim

