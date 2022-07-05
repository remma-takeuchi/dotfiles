#!/bin/bash

scriptdir=$(cd $(dirname $0); pwd)
export DOTFILES_ROOT=`realpath ${scriptdir}/../`
cd ${scriptdir}

# Install modules
./lib/prepare_minimal_packages.sh
./lib/prepare_ritch_packages.sh

# link configurations
./lib/link_dotfiles.sh

# Install vim plugins
./lib/finalize_minimal_packages.sh
./lib/finalize_ritch_packages.sh

popd > /dev/null

