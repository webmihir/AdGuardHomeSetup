#!/bin/bash

if [[ $EUID -ne 0 ]]
then
	echo "  - This script must be run as root."
	echo "  - Try running the command with \"sudo\"."
	exit 1
fi

