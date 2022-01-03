#!/bin/bash

function install_deb_from_url () {
  cmdname=$1
  deburl=$2

  type $cmdname > /dev/null
  rc=$?
  if [[ $rc -eq 0 ]]; then
    exit 0
  fi

  pushd /tmp/ > /dev/null
  wget -O out.deb $deburl && \
  sudo apt install ./out.deb
  rm -f ./out.deb
  popd > /dev/null
}

os_type=`uname`


# Debian
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
  DEBIAN_FRONTEND=noninteractive sudo apt install -y locales-all

  install_deb_from_url rg https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
  install_deb_from_url fd https://github.com/sharkdp/fd/releases/download/v8.3.0/fd_8.3.0_amd64.deb


# Mac
elif [[ $os_type == "Darwin" ]]; then
  brew install fzf
fi


# Common
# FZF
type fzf > /dev/null
rc=$?
if [[ $rc -ne 0 ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all --xdg --key-bindings --completion --update-rc --no-bash --no-fish
fi

# Python packages
pip3 install pynvim

