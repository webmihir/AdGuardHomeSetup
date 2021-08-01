#!/bin/bash

if [[ $EUID -ne 0 ]]
then
	echo "  - This script must be run as root."
	echo "  - Try: sudo $0 $@"
	exit 1
fi

