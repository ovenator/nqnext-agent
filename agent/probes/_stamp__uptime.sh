#!/bin/sh

UPTIME_SECONDS=$(cat /proc/uptime  | tee tee /dev/tty | awk '{ print $1 }')

echo "{{_value:$UPTIME_SECONDS}}"
echo "{{_unit:s}}"
echo "{{_label:Uptime}}"
echo "{{_preview:true}}"