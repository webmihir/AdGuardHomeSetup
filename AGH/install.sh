#!/bin/bash

source "$SCRIPT_DIR/common/lib.sh"

while getopts u:p: flag
do
	case $flag in
		u) AGH_USERNAME="$OPTARG";;
		p) AGH_PASSWORD="$OPTARG";;
	esac
done

if [[ -z "$AGH_USERNAME" || -z "$AGH_PASSWORD" ]]
then
	echo "Username and Password must not be empty."
	exit 1
fi

AGH_HOME=/opt/AdGuardHome
if [ -f "$AGH_HOME/AdGuardHome" ]
then
	echo "Uninstalling current AdGuardHome installation first..."
	$AGH_HOME/AdGuardHome -s stop >/dev/null 2>&1
	curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -u >/dev/null 2>&1
fi

echo "Installing AdGuardHome Beta ..."
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -c beta >/dev/null 2>&1

echo "Waiting for AdGuardHome Service to start ..."
# TODO: Change this to poll port 3000 until 2xx response code is received
sleep 10

echo "Creating initial configuration for AdGuardHome Service ..."
curl 'http://localhost:3000/control/install/configure' -H 'Content-Type: application/json' --data-raw '{"web": {"ip":"0.0.0.0", "port":8001, "status": "", "can_autofix":false}, "dns": {"ip":"0.0.0.0", "port": 53, "status":"", "can_autofix":false}, "username":"'$AGH_USERNAME'", "password":"'$AGH_PASSWORD'"}'

