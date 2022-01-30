#!/bin/sh

cat /proc/meminfo | egrep 'Swap'
SWAP_TOTAL=$(cat /proc/meminfo | egrep 'SwapTotal' | awk '{ print $2 }')
SWAP_AVAIL=$(cat /proc/meminfo | egrep 'SwapFree' | awk '{ print $2 }')
SWAP_USED=$(($SWAP_TOTAL - $SWAP_AVAIL))

echo "{{_max:$SWAP_TOTAL}}"
echo "{{_value:$SWAP_USED}}"
echo "{{_unit:kb}}"
echo "{{_label:Swap}}"
echo "{{_preview:true}}"