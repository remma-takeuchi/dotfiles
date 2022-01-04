#!/bin/bash

scriptdir=$(cd $(dirname $0); pwd)
DOTFILES_ROOT=`realpath ${scriptdir}/../`

docker run --rm -it \
  -v $DOTFILES_ROOT:/dotfiles \
  -v ~/Projects:/Projects \
  ubuntu:latest /dotfiles/install_scripts/install_dotfiles.sh

