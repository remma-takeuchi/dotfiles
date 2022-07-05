#!/bin/bash

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
  install_tmux


