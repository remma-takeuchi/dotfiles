#!/bin/bash

function install_tzdata(){
  ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
  DEBIAN_FRONTEND=noninteractive apt install -y tzdata
  dpkg-reconfigure --frontend noninteractive tzdata
}

function install_deb_from_url () {
  cmdname=$1
  deburl=$2

  type $cmdname > /dev/null
  rc=$?
  if [[ $rc -eq 0 ]]; then
    return 0
  fi

  pushd /tmp/ > /dev/null
  wget -O out.deb $deburl && \
  sudo apt install ./out.deb
  rm -f ./out.deb
  popd > /dev/null
}

function install_clangd () {
  zipurl="https://github.com/clangd/clangd/releases/download/13.0.0/clangd-linux-13.0.0.zip"

  type clangd > /dev/null
  rc=$?
  if [[ $rc -eq 0 ]]; then
    return 0
  fi

  tempdir=`mktemp -d`
  mkdir -p $tempdir
  pushd $tempdir > /dev/null
  wget -O out.zip $zipurl && \
    unzip out.zip && \
    sudo mv ./clangd_13.0.0/bin/clangd /usr/local/bin && \
    sudo mv ./clangd_13.0.0/lib/clang /usr/local/lib
  popd > /dev/null
  rm -rf $tempdir
}

function install_tmux () {
  tarballurl="https://github.com/tmux/tmux/releases/download/3.2a/tmux-3.2a.tar.gz"

  type tmux > /dev/null
  rc=$?
  if [[ $rc -eq 0 ]]; then
    return 0
  fi

  export DEBIAN_FRONTEND=noninteractive
  # DEBIAN_FRONTEND=noninteractive sudo apt install -y -q libevent-dev ncurses-dev build-essential bison pkg-config
  sudo apt install -y -q libevent-dev ncurses-dev build-essential bison pkg-config

  tempdir=`mktemp -d`
  mkdir -p $tempdir
  pushd $tempdir > /dev/null
  wget $tarballurl && \
    tar -zxf tmux-*.tar.gz && \
    cd tmux-*/  && \
    ./configure && \
    make && sudo make install && \
  popd > /dev/null
  rm -rf $tempdir
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
  install_tzdata

  DEBIAN_FRONTEND=noninteractive sudo apt install -y git wget curl zip
  # DEBIAN_FRONTEND=noninteractive sudo apt install -y zsh tmux
  DEBIAN_FRONTEND=noninteractive sudo apt install -y zsh
  DEBIAN_FRONTEND=noninteractive sudo apt install -y python3 python3-pip python3-venv
  DEBIAN_FRONTEND=noninteractive sudo apt install -y locales-all
  DEBIAN_FRONTEND=noninteractive sudo apt install -y jq

  install_deb_from_url rg https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
  install_deb_from_url fd https://github.com/sharkdp/fd/releases/download/v8.3.0/fd_8.3.0_amd64.deb
  install_deb_from_url bat https://github.com/sharkdp/bat/releases/download/v0.18.3/bat_0.18.3_amd64.deb

  install_clangd
  install_tmux

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

