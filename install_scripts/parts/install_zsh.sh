#!/bin/bash

os_type=`uname`

# Debian
if [[ $os_type == "Linux" ]]; then
  DEBIAN_FRONTEND=noninteractive sudo apt install -y zsh
fi

