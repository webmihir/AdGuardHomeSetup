#!/bin/bash
  
if [[ $EUID -ne 0 ]]
then
        echo "This script must be run as root."
        echo "Try: sudo $0 $@"
        exit 1
fi

CUR_DIR=`dirname "$(readlink -f "$0")"`

echo "Downloading scripts from github into $HOME/github/ directory ..."
if [ -d "$HOME/github/AdGuardHomeSetup" ]
then
	echo "  - Deleting existing $HOME/github/AdGuardHomeSetup directory."
	rm -rf "$HOME/github/AdGuardHomeSetup" >/dev/null 2>&1
fi
mkdir -p $HOME/github/ >/dev/null 2>&1
pushd $HOME/github/
echo "DO NOT DELETE THIS DIRECTORY AND ITS CONTENTS. THEY ARE USED IN CRON JOBS TO ENSURE YOUR INSTALLATION STAYS UP TO DATE." > "DO_NOT_DELETE"
git clone https://github.com/webmihir/AdGuardHomeSetup.git >/dev/null 2>&1

echo "Running Initial Setup to install required packages"
$HOME/github/AdGuardHomeSetup/packages/install.sh


popd

