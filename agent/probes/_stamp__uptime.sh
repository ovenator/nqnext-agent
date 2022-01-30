#!/bin/sh

cat /proc/uptime
UPTIME_SECONDS=$(cat /proc/uptime | awk '{ print $1 }')

echo "{{_value:$UPTIME_SECONDS}}"
echo "{{_unit:s}}"
echo "{{_label:Uptime}}"
echo "{{_preview:true}}"