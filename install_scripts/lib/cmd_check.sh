#!/bin/bash

if type sudo > /dev/null 2>&1; then
    apt update && apt install sudo
fi

