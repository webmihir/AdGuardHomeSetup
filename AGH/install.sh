#!/bin/bash

source $SCRIPT_DIR/common/lib.sh

AGH_USERNAME="$2"
AGH_PASSWORD="$4"

echo "Installing AdGuardHome Beta ...."
AGH_HOME=/opt/AdGuardHome
if [ -f "$AGH_HOME/AdGuardHome" ]
then
	echo "Uninstalling current AdGuardHome installation first..."
	$AGH_HOME/AdGuardHome -s stop
	curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -u
fi

curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -c beta
sleep 10
curl 'http://localhost:3000/control/install/configure' -H 'Content-Type: application/json' --data-raw '{"web": {"ip":"0.0.0.0", "port":8001, "status": "", "can_autofix":false}, "dns": {"ip":"0.0.0.0", "port": 53, "status":"", "can_autofix":false}, "username":"'$AGH_USERNAME'", "password":"'$AGH_PASSWORD'"}'

