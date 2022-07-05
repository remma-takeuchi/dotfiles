#!/bin/bash

scriptdir=$(cd $(dirname $0); pwd)
export DOTFILES_ROOT=`realpath ${scriptdir}/../`

# Install modules
./lib/prepare_minimal_packages.sh

# link configurations
./lib/link_dotfiles.sh

# Install vim plugins
./lib/finalize_minimal_packages.sh

popd > /dev/null

