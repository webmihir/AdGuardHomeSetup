#!/bin/bash
  
if [[ $EUID -ne 0 ]]
then
        echo "This script must be run as root."
        echo "Try: sudo $0 $@"
        exit 1
fi

export CUR_DIR=`dirname "$(readlink -f "$0")"`
export INSTALL_DIR=$HOME/github
export SCRIPT_DIR=$INSTALL_DIR/AdGuardHomeSetup

# TODO: Change these to query parameters
AGH_USERNAME="admin"
AGH_PASSWORD="1234"
INSTALL_AGH=1
INSTALL_SSL=1
INSTALL_WIREGUARD=1

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

