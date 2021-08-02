#!/bin/bash

source $SCRIPT_DIR/common/lib.sh

echo "Installing AdGuardHome Beta ...."
AGH_HOME=/opt/AdGuardHome
if [ -f "$AGH_HOME/AdGuardHome" ]
then
	echo "Uninstalling current AdGuardHome installation first..."
	$AGH_HOME/AdGuardHome -s stop
	curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -u
fi

curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -c beta
curl 'http://localhost:3000/control/install/configure' -H 'Content-Type: application/json' --data-raw '{"web": {"ip":"0.0.0.0", "port":8001, "status": "", "can_autofix":false}, "dns": {"ip":"0.0.0.0", "port": 53, "status":"", "can_autofix":false}, "username":"admin", "password":"'$AGH_PASSWORD'"}'

$AGH_HOME/AdGuardHome -s start
