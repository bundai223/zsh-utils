#!/bin/bash

if [ ! -d ~/.config/zsh ]; then
  mkdir -p ~/.config/zsh
fi

if [ ! -e ~/.config/zsh/zsh-utils ]; then
  ln -s ~/repos/github.com/bundai223/zsh-utils ~/.config/zsh/zsh-utils
fi
