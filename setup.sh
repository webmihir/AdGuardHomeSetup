#!/bin/bash
  
if [[ $EUID -ne 0 ]]
then
        echo "This script must be run as root."
        echo "Try: sudo $0 $@"
        exit 1
fi

show_help() {
	echo "Usage:"
	echo "$0 -u \"<AdGuardHome Username>\" -p \"<AdGuardHome Password>\" -a 1 -w 1"
	echo "   -u: AdGuardHome Username. Default: \"admin\""
	echo "   -p: AdGuardHome Password. Mandatory Parameter must be supplied if \"-a 1\" flag is used."
	echo "   -a: 0 (do not install AdGuardHome) or 1 (Install AdGuardHome). Default=1."
	echo "   -w: 0 (do not install WireGuard) or 1 (Install WireGuard). Default=1."
	echo ""
	echo "Example:"
	echo "  $0 -u \"admin\" -p \"P@ssw0rd\""
}

export CUR_DIR=`dirname "$(readlink -f "$0")"`
export INSTALL_DIR=$HOME/github
export SCRIPT_DIR=$INSTALL_DIR/AdGuardHomeSetup

AGH_USERNAME="admin"
INSTALL_AGH=1
INSTALL_SSL=1
INSTALL_WIREGUARD=1

while getopts u:p:a:w:h flag
do
	case "${flag}" in
		u) AGH_USERNAME="${OPTARG}";;
		p) AGH_PASSWORD="${OPTARG}";;
		a) INSTALL_AGH=$OPTARG;;
		w) INSTALL_WIREGUARD=$OPTARG;;
		h) show_help; exit 0;;
	esac
done
if [ $INSTALL_AGH -eq 1 ]
then
	if [ -z "$AGH_PASSWORD" ]
	then
		echo "No Password set for AdGuardHome using -p flag."
		show_help
		exit 1
	fi
fi

echo "Downloading scripts from github into $HOME/github/ directory ..."
if [ -d "$SCRIPT_DIR" ]
then
	echo "  - Deleting existing $SCRIPT_HOME directory."
	rm -rf "$SCRIPT_DIR" >/dev/null 2>&1
fi
mkdir -p $INSTALL_DIR >/dev/null 2>&1
pushd $INSTALL_DIR >/dev/null 2>&1
echo "DO NOT DELETE THIS DIRECTORY AND ITS CONTENTS. THEY ARE USED IN CRON JOBS TO ENSURE YOUR INSTALLATION STAYS UP TO DATE." > "DO_NOT_DELETE"
git clone https://github.com/webmihir/AdGuardHomeSetup.git >/dev/null 2>&1

echo "Running Initial Setup to install required packages"
source $SCRIPT_DIR/packages/install.sh

echo "Installing AdGuardHome ..."
if [ $INSTALL_AGH -eq 1 ]
then
	source $SCRIPT_DIR/AGH/install.sh -u "$AGH_USERNAME" -p "$AGH_PASSWORD"
fi

popd >/dev/null 2>&1

