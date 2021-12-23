#!/bin/bash

vim +'PlugInstall' +qall

nvim +'CocInstall -sync coc-json' +qall
nvim +'CocInstall -sync coc-snippets' +qall
#nvim +'CocInstall -sync coc-jedi' +qall

vim +CocUpdateSync +qall

