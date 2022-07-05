#!/bin/bash

function install_clangd () {
  zipurl="https://github.com/clangd/clangd/releases/download/13.0.0/clangd-linux-13.0.0.zip"

  type clangd > /dev/null
  rc=$?
  if [[ $rc -eq 0 ]]; then
    return 0
  fi

  tempdir=`mktemp -d`
  mkdir -p $tempdir
  pushd $tempdir > /dev/null
  wget -O out.zip $zipurl && \
    unzip out.zip && \
    sudo mv ./clangd_13.0.0/bin/clangd /usr/local/bin && \
    sudo mv ./clangd_13.0.0/lib/clang /usr/local/lib
  popd > /dev/null
  rm -rf $tempdir
}

os_type=`uname`

# Debian
if [[ $os_type == "Linux" ]]; then
  install_clangd

