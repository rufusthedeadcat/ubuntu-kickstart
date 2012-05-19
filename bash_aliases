#!/bin/bash

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias gapt='sudo apt-get'
alias bd='cd -'

alias webs='python -m SimpleHTTPServer'
alias webshare='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'

alias folders='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'

alias install='sudo apt-get update && sudo apt-get install'


### Functions

repeat () {
	n=$1
	shift
	while [ $(( n -= 1 )) -ge 0 ]
	do
		"$@"
	done
}


whatip() {
    if [ $# != 1 ]; then
        echo "Usage: whatip <ip address>"
    else
        nslookup $1 | grep Add | grep -v '#' | cut -f 2 -d ' '
    fi
}


mkcd() {
    if [ $# != 1 ]; then
        echo "Usage: mkcd <dir>"
    else
        mkdir -p $1 && cd $1
    fi
}

up() {
    local d=".."
    limit=$1
    if [ $1 -gt 1 ]; then
      for i in {1..$1}
        do
          d=$d/..
        done
    fi
    cd $d
}

extract() {
    if [ -f $1 ]; then
        case $1 in 
            *.tar.bz2)  tar xvjf $1 ;;
            *.tar.gz)   tar xvzf $1 ;;
            *.bz2)      bunzip2 $1 ;;
            *.rar)      unrar x $1 ;;
            *.gz)       gunzip $1 ;;
            *.tar)      tar xvf $1 ;;
            *.tbz2)     tar xvjf $1 ;;
            *.tgz)      tar xvzf $1 ;;
            *.zip)      unzip $1 ;;
            *.Z)        uncompress $1 ;;
            *.7z)       7z x $1 ;;
	    *)          echo "'$1' cannot be extracted via extract" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

passgen() {
    echo $(< /dev/urandom tr -dc A-Za-z0-9_ | head -c$1)
}

coinflip() {
	if [[ $(($RANDOM % 2)) -eq 1 ]]; then
		echo "Heads";
	else
		echo "Tails"
	fi
}




findclass() {
	# lame, i hate working with bash arrays
	if [ $# == 2 ]
	then
		find "$1" -name "*.jar" -exec sh -c 'jar -tf {}|grep -H --label {} '$2'' \;
	else
		find "." -name "*.jar" -exec sh -c 'jar -tf {}|grep -H --label {} '$1'' \;
	fi
	
}

bkup() {
    mv $1 $1.bkup
}

bkdown() {
    mv $1 " basename "$1" .bkup"
}


histgrep() {
	_grh="$@"
	history | grep "$_grh"
}

wiki() {
	dig +short txt $1.wp.dg.cx
}

screencast(){
	ffmpeg -f x11grab -s wxga -r 25 -i :0.0 -sameq $1
}


# http://madebynathan.com/2011/10/04/a-nicer-way-to-use-xclip/
#
# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# - If the input is a filename that exists, then it
#   uses the contents of that file.
# ------------------------------------------------
cb() {
  local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
  # Check user is not root (root doesn't have access to user xorg server)
  elif [ "$USER" == "root" ]; then
    echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
  else
    # If no tty, data should be available on stdin
    if [ "$( tty )" == 'not a tty' ]; then
      input="$(< /dev/stdin)"
    # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then  # If no input, print usage message.
      echo "Copies a string or the contents of a file to the clipboard."
      echo "Usage: cb <string or file>"
      echo "       echo <string or file> | cb"
    else
      # If the input is a filename that exists, then use the contents of that file.
      if [ -e "$input" ]; then input="$(cat $input)"; fi
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
    fi
  fi
}

# adjust cb() for copying paths
cbp() {
  input="$*"
  echo -n "$input" | xclip -selection c
  # Truncate text for status
  if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
  # Print status.
  echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
}
