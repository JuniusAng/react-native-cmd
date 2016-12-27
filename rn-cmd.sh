#!/bin/bash

VAR_SRC="$HOME/.rncmdrc"
ADB=$(which adb)
EMU=$(which emulator)
EMU_ARGS="-netdelay none -netspeed full -avd"
#sample
ANDROID_DIR="/home/junius/project/"
touch "$VAR_SRC"
source "$VAR_SRC"
SELECTED_FILE=""
SELECTED_INPUT=""

function cls(){
	printf "\033c"
}

function runInNewWindow(){
	echo "cmd : $1"
	gnome-terminal -e "bash -c \"$1 ; exec bash\""
}

function runInNewWindowSmall(){
	gnome-terminal --geometry=80x10 -x bash -c "$1"
}
function runAndDisown(){
	eval "$1 & disown"
}

function runCommand(){
	echo ""
}

function initScript(){
	if [ ! -d "VAR_SRC" ]; then
		echo "testing not found"
	fi
}

function menu(){
	echo "1. START EMULATOR"
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
function scanInput(){
	prompt="Please select:"
	options=( $($1 -print0 | xargs -0) )

	PS3="$prompt "
	select opt in "${options[@]}" "Quit" ; do
    if (( REPLY == 1 + ${#options[@]} )) ; then
	    SELECTED_INPUT=""
      exit

    elif (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
			SELECTED_INPUT="$opt"
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

VALID=true
while $VALID; do

	menu
	echo -n "CHOICE [] : "
	read chc
	if [ "$chc" = "1" ]; then
		scanInput "$EMU -list-avds"
		if [ ! $SELECTED_INPUT = "" ]; then
			runInNewWindowSmall "$EMU $EMU_ARGS $SELECTED_INPUT"
		fi
	fi
done
echo "$ADB $EMU"
#scanDir "/home/junius"
#echo $SELECTED_FILE
##ls ~/project $opt
#initScript
#ask "Do you wish to install this program?" "pwd; sleep 3; ls -l;sleep 3;exit"
