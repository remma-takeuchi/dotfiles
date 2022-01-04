#!/bin/bash

vim +'PlugInstall' +qall

vim +'CocInstall -sync coc-json' +qall
vim +'CocInstall -sync coc-snippets' +qall
vim +'CocInstall -sync coc-jedi' +qall
vim +'CocInstall -sync coc-clangd' +qall

vim +CocUpdateSync +qall

