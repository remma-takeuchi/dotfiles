#!/bin/bash

# clangd
function install_clangd () {

    type clangd > /dev/null
    rc=$?
    if [[ $rc -eq 0 ]]; then
        return 0
    fi

    os_type=`uname`
    if [[ $os_type == "Linux" ]]; then
        zipurl="https://github.com/clangd/clangd/releases/download/13.0.0/clangd-linux-13.0.0.zip"
        tempdir=`mktemp -d`
        mkdir -p $tempdir
        pushd $tempdir > /dev/null
        wget -O out.zip $zipurl && \
            unzip out.zip && \
            sudo mv ./clangd_13.0.0/bin/clangd /usr/local/bin && \
            sudo mv ./clangd_13.0.0/lib/clang /usr/local/lib
        popd > /dev/null
        rm -rf $tempdir
    fi
}

# nodejs
function install_nodejs () {

    type node > /dev/null
    rc=$?
    if [[ $rc -eq 0 ]]; then
        return 0
    fi

    os_type=`uname`
    if [[ $os_type == "Linux" ]]; then
        # Nodejs for coc.nvim
        curl -sL https://deb.nodesource.com/setup_current.x | sudo -E bash -
        DEBIAN_FRONTEND=noninteractive sudo apt install -y nodejs
    fi
}


install_clangd
install_nodejs

# Debian
if [[ $os_type == "Linux" ]]; then
  DEBIAN_FRONTEND=noninteractive sudo apt install -y python3 python3-pip python3-venv
fi

# Python packages
pip3 install pynvim

