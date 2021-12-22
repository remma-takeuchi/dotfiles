#!/bin/bash

# Install zsh
function neovim_nightly() {
  # nightly
  curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
  chmod u+x nvim.appimage
  sudo mv nvim.appimage /usr/local/bin
  
  sudo ln -snf /usr/local/bin/nvim.appimage /usr/local/bin/nvim

  pushd /usr/local/bin/ > /dev/null
  ./nvim.appimage --appimage-extract
  ln -snf `realpath ./squashfs-root/usr/bin/nvim` ./
  ln -snf nvim vim
  #rm -rf ./squashfs-root ./nvim.appimage

  popd > /dev/null
}

#DEBIAN_FRONTEND=noninteractive sudo apt install -y fuse

# Neovim
neovim_nightly

# Vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Nodejs for coc.nvim
curl -sL https://deb.nodesource.com/setup_current.x | sudo -E bash -
DEBIAN_FRONTEND=noninteractive sudo apt install -y nodejs
