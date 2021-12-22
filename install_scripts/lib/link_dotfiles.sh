#!/usr/bin/env zsh

pushd ${DOTFILES_ROOT} > /dev/null

ln -fs ${DOTFILES_ROOT}/.p10k.zsh ${HOME}
ln -fs ${DOTFILES_ROOT}/.tmux.conf ${HOME}
ln -fs ${DOTFILES_ROOT}/.zshrc ${HOME}

ln -fs ${DOTFILES_ROOT}/.vimrc ${HOME}
mkdir -p ${HOME}/.config
ln -fs ${DOTFILES_ROOT}/.config/nvim/ ${HOME}/.config/

popd > /dev/null
