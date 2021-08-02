#!/bin/bash

source $SCRIPT_DIR/common/lib.sh

echo "Installing AdGuardHome Beta ...."
AGH_HOME=/opt/AdGuardHome
if [ -f "$AGH_HOME/AdGuardHome" ]
then
	$AGH_HOME/AdGuardHome -s stop
	curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -u
fi

AGH_PASS=`htpasswd -nbB admin '$AGH_PASSWORD' | tr -d 'admin:'`
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -c beta
$AGH_HOME/AdGuardHome -s stop >/dev/null 2>&1

cat $SCRIPT_DIR/AGH/AdGuardHome.yaml | tr -s 'ENTERPASSWORDHERE' "$AGH_PASSWORD"> $AGH_HOME/AdGuardHome.yaml

$AGH_HOME/AdGuardHome -s start
