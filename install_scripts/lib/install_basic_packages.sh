#!/bin/bash

if type sudo > /dev/null 2>&1; then
    apt update && apt install sudo
fi

sudo apt update
DEBIAN_FRONTEND=noninteractive sudo apt install -y git wget curl 
DEBIAN_FRONTEND=noninteractive sudo apt install -y zsh tmux
DEBIAN_FRONTEND=noninteractive sudo apt install -y python3 python3-pip

pip3 install pynvim

