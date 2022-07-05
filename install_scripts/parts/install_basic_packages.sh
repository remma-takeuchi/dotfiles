#!/bin/bash

function install_tzdata(){
  ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
  DEBIAN_FRONTEND=noninteractive apt install -y tzdata
  dpkg-reconfigure --frontend noninteractive tzdata
}

os_type=`uname`

# Debian
if [[ $os_type == "Linux" ]]; then

  type sudo > /dev/null 2>&1
  rc=$?
  if [ $rc != 0 ] ; then
    DEBIAN_FRONTEND=noninteractive apt update && \\
    DEBIAN_FRONTEND=noninteractive apt install sudo
  fi

  sudo apt update
  install_tzdata
  DEBIAN_FRONTEND=noninteractive sudo apt install -y git wget curl zip
  DEBIAN_FRONTEND=noninteractive sudo apt install -y locales-all
  DEBIAN_FRONTEND=noninteractive sudo apt install -y jq
fi

