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
