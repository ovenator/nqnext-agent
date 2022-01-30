#!/bin/sh

OUTPUT=$(df -P -k | grep '/$')
echo $OUTPUT
DISK_TOTAL=$(echo $OUTPUT | awk '{print $2}')
DISK_USED=$(echo $OUTPUT | awk '{print $3}')

echo "{{_max:$DISK_TOTAL}}"
echo "{{_value:$DISK_USED}}"
echo "{{_unit:kb}}"
echo "{{_label:Disk /}}"
echo "{{_preview:true}}"