#!/bin/sh

cat /proc/meminfo | egrep 'Mem'
MEM_TOTAL=$(cat /proc/meminfo | egrep 'MemTotal' | awk '{ print $2 }')
MEM_AVAIL=$(cat /proc/meminfo | egrep 'MemAvailable' | awk '{ print $2 }')
MEM_USED=$(($MEM_TOTAL - $MEM_AVAIL))

echo "{{_max:$MEM_TOTAL}}"
echo "{{_value:$MEM_USED}}"
echo "{{_unit:kb}}"
echo "{{_label:Memory}}"
echo "{{_preview:true}}"