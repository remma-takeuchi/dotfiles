#!/bin/bash

scriptdir=$(cd $(dirname $0); pwd)
export DOTFILES_ROOT=`realpath ${scriptdir}/../`

# Install modules
pushd ${DOTFILES_ROOT}/install_scripts > /dev/null
./lib/install_basic_packages.sh
./lib/install_neovim.sh
./lib/install_zshplugins.sh

# link configurations
./lib/link_dotfiles.sh

# Install vim plugins
./lib/install_neovim_minimal_plugins.sh

popd > /dev/null

zsh
