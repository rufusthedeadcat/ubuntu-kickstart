#!/bin/bash

DIRECTORY=$(cd `dirname $0` && pwd)

#ln -s $@ $DIRECTORY/vimrc $HOME/.vimrc
ln -s $@ $DIRECTORY/bashrc $HOME/.bashrc
#ln -s $@ $DIRECTORY/vim $HOME/.vim
ln -s $@ $DIRECTORY/bash_aliases $HOME/.bash_aliases
#ln -s $@ $DIRECTORY/pythonrc $HOME/.pythonrc

# setup git global settings
git config --global alias.st  status
git config --global alias.ci  commit
git config --global alias.co  checkout
git config --global alias.ls  ls-files
