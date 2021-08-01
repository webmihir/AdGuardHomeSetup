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
$SCRIPT_DIR/packages/install.sh


popd >/dev/null 2>&1

