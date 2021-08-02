#!/bin/bash

if [ ${0##*/} == ${BASH_SOURCE[0]##*/} ]; then
    echo "WARNING"
    echo "This script is not meant to be executed directly!"
    echo "See: https://github.com/webmihir/AdGuardHomeSetup/blob/main/README.md"
    echo
    exit 1
fi

source "$SCRIPT_DIR/common/lib.sh"

echo "  - Upgrading apt-get packages ..."
apt-get update >/dev/null 2>&1
apt-get --yes upgrade >/dev/null 2>&1

REQUIRED_PKGS="vim,python3,dnsutils,cron,snap,apache2-utils,apache2"

ORIG_IFS=$IFS
IFS=,
for pkg in $REQUIRED_PKGS
do
	draw-line
	apt-get-install $pkg
	draw-line
done
IFS=$ORIG_IFS

echo "  - Installing SNAP packages now ...."

SNAP_PKGS="certbot"
IFS=,
for pkg in $SNAP_PKGS
do
	echo "  - ********** ********** ********** ********** ********** **********"
	echo "  - Checking if $pkg is installed ..."
	snap list | grep $pkg | grep -v grep >/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo "    - Snap $pkg is not installed. Installing it now..."
		snap install $pkg --classic >/dev/null 2>&1
	else
		echo "    - Snap $pkg is already installed. Skipping ..."
	fi
	echo "  - ********** ********** ********** ********** ********** **********"
done
IFS=$ORIG_IFS
