#!/bin/bash
# Written by --REDACTED--
# Requires: DING_DOMAIN_SUFFIX

work_path=$(dirname $(readlink -f $0))
cd "$work_path"

echo "Ding watch Written by --REDACTED--"
echo "Subdomain $1, port $2"
subdomain=$1
port=$2

if [ -z "$DING_DOMAIN_SUFFIX" ]; then
    DING_DOMAIN_SUFFIX="vaiwan.cn"
fi

function startDing {
    rm -f $log
    nohup $work_path/ding -config="$work_path/ding.cfg" -subdomain=$subdomain $port &
}

function killDing {
    pkill -SIGKILL ding
}

startDing

while true
do
    if grep -q "$DING_DOMAIN_SUFFIX:" "$log"; then
        echo "Port is not 80. killing"
        killDing
        sleep 0.5s
        startDing
    fi
    
    sleep 3s
done

