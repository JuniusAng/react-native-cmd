#!/bin/bash

VAR_SRC="$HOME/.rn-cmd.sh"
touch "$VAR_SRC"
source "$VAR_SRC"
SELECTED_FILE=""

function runInNewWindow(){
	echo "cmd : $1"
	gnome-terminal -e "bash -c \"$1; exec bash\""
}

function runCommand(){
	echo ""
}

function initScript(){
	if [ ! -d "VAR_SRC" ]; then
		echo "testing not found"
	fi
}

#$1 = Question string
function scanDir(){
	prompt="Please select a file:"
	options=( $(find $1 -maxdepth 1 -print0 | xargs -0) )

	PS3="$prompt "
	select opt in "${options[@]}" "Quit" ; do 
    if (( REPLY == 1 + ${#options[@]} )) ; then
	    SELECTED_FILE=""
      exit

    elif (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
      echo  "You picked $opt which is file $REPLY"
			SELECTED_FILE="$opt"
      break

    else
      echo "Invalid option. Try another one."
    fi
	done  
}

#$1 = Question string
#$2 = Command
function ask(){
	echo "$1"
	select yn in "Yes" "No"; do
		  case $yn in
		      Yes ) runInNewWindow "$2" ; break;;
		      No ) break;;
		  esac
	done
}

  
scanDir "/home/junius"
echo $SELECTED_FILE
##ls ~/project $opt
#initScript
#ask "Do you wish to install this program?" "pwd; sleep 3; ls -l;sleep 3;exit"



