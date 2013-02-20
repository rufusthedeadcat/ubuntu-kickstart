#!/bin/bash

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias bd='cd -'

alias webs='python -m SimpleHTTPServer'
alias webshare='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'
alias fakemail='python -m smtpd -n -c DebuggingServer localhost:20025'

alias gapt='sudo apt-get'
alias update='sudo apt-get update'
alias install='sudo apt-get install'
alias upstall='sudo apt-get update && sudo apt-get install'
alias noise='tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;3$(($RANDOM % 8))" grep --color "[^ ]"'
alias distract='cat /dev/urandom | hexdump -C | grep "ca fe"'
alias cls='printf "\033c"'

### Functions

#Calculator (The equation cannot have spaces)
# > ? 5+5
# > 10
? () { echo "$*" | bc -l; }

#Repeat a command n times
repeat () {
	n=$1
	shift
	while [ $(( n -= 1 )) -ge 0 ]
	do
		"$@"
	done
}

#Lists the ip(s) for a domain name
# > whatip google.com
whatip() {
    if [ $# != 1 ]; then
        echo "Usage: whatip <ip address>"
    else
        nslookup $1 | grep Add | grep -v '#' | cut -f 2 -d ' '
    fi
}

# Makes a directory of the specified name and immediately switches to that directory
mkcd() {
    if [ $# != 1 ]; then
        echo "Usage: mkcd <dir>"
    else
        mkdir -p $1 && cd $1
    fi
}

#Copy with a progress bar
cp_p() {
   strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
      | awk '{
        count += $NF
            if (count % 10 == 0) {
               percent = count / total_size * 100
               printf "%3d%% [", percent
               for (i=0;i<=percent;i++)
                  printf "="
               printf ">"
               for (i=percent;i<100;i++)
                  printf " "
               printf "]\r"
            }
         }
         END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
}

#Changes directories up the specified number
up() { [ $(( $1 + 0 )) -gt 0 ] && cd $(eval "printf '../'%.0s {1..$1}"); }

#A handy command to uncompress a variety of archive files
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

#Generate a alphanumeric password/random string
passgen() {
    echo $(< /dev/urandom tr -dc A-Za-z0-9_ | head -c$1)
}

#Flip a coin
coinflip() {
	if [[ $(($RANDOM % 2)) -eq 1 ]]; then
		echo "Heads";
	else
		echo "Tails"
	fi
}


#Search for java classes in jars
findclass() {
	# lame, i hate working with bash arrays
	if [ $# == 2 ]
	then
		find "$1" -name "*.jar" -exec sh -c 'jar -tf {}|grep -H --label {} '$2'' \;
	else
		find "." -name "*.jar" -exec sh -c 'jar -tf {}|grep -H --label {} '$1'' \;
	fi
}

#Create a copy of a file with a .bkup suffix
bkup() {
    cp $1 $1.bkup
}

#Restore a .bkup file
bkdown() {
    mv $1 " basename "$1" .bkup"
}

#Grep your bash history
histgrep() {
	_grh="$@"
	history | grep "$_grh"
}

#Grab the summary from the corresponding wikipedia page
wiki() {
	dig +short txt $1.wp.dg.cx
}

#Has issues, look into using avconv instead
#screencast(){
#	ffmpeg -f x11grab -s wxga -r 25 -i :0.0 -sameq $1
#}

#Simple timer
timeit(){
	echo "Press any key to stop"
	time read -sn1
}

#Slowly echo the input back out to the screen
slowecho(){
	echo $1 | pv -qL 10
}

#Kill the parent process of a mouse-clicked X window 
xmurder(){
	WINDOW_ID=`xwininfo | grep "Window id:" | awk '{print $4}'`
	PROCESS_ID=`xprop -id $WINDOW_ID _NET_WM_PID | awk '{print $3}'`
	kill -9 $PROCESS_ID
}

#Sort the directory (and subdirectories) files by file extention with count and total size
sortbytype(){
	for ext in $( find . -type f | grep -o '\.[^./]*$' | sort | uniq -i); do
    		echo -n "${ext} "
		find . -iname "*${ext}" -exec du -b {} + | awk 'BEGIN { size=0; count=0 } { size+=$1; count++ } END { print count, size }'
	done
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
