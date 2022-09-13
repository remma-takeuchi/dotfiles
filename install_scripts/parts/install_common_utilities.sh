#!/bin/bash

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

# rg
install_deb_from_url rg https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb

# fd
install_deb_from_url fd https://github.com/sharkdp/fd/releases/download/v8.3.0/fd_8.3.0_amd64.deb

# bat
install_deb_from_url bat https://github.com/sharkdp/bat/releases/download/v0.18.3/bat_0.18.3_amd64.deb

# # neovim
# install_deb_from_url nvim https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb

