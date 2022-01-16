#!/bin/sh

df -P -k | grep '/$'

echo "{{_label:Disk /}}"
echo "{{_preview:true}}"