#!/bin/sh

MINUTE_AVG_LOAD=$(cat /proc/loadavg | tee tee /dev/tty | awk '{ print $1 }')
CPU_CORES=$(nproc)

echo "{{_max:$CPU_CORES}}"
echo "{{_value:$MINUTE_AVG_LOAD}}"
echo "{{_label:Load}}"
echo "{{_preview:true}}"