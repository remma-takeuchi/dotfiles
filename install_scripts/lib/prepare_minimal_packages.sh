#!/bin/bash

# Install modules
${DOTFILES_ROOT}/install_scripts/parts/install_basic_packages.sh
${DOTFILES_ROOT}/install_scripts/parts/install_common_utilities.sh
${DOTFILES_ROOT}/install_scripts/parts/install_fzf.sh
${DOTFILES_ROOT}/install_scripts/parts/install_neovim.sh

