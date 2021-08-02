#!/bin/bash

check-root-access() {
	if [[ $EUID -ne 0 ]]
	then
		echo "  - This script must be run as root."
		echo "  - Try running the command with \"sudo\"."
		exit 1
	fi
}

apt-get-install() {
        echo "  - Checking if $1 is installed ..."
        PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $1|grep "install ok installed")
        if [ "" = "$PKG_OK" ]
        then
                echo "    - Package $1 is not installed. Installing it now..."
                apt-get --yes install $1 >/dev/null 2>&1
        else
                echo "    - Package $1 is already installed. Skipping ..."
        fi
}

draw-line() {
	echo "********** ********** ********** ********** ********** **********"
}

check-root-access

