#!/bin/bash

API_URL="https://status.netsyms.net/api/push/"
HEARTBEAT_KEY=""
ZFS_KEY=""
DISK_KEY=""
DISK_FULL_ALERT_PERCENT_THRESHOLD=85

# Heartbeat
echo "Sending heartbeat"
curl "$API_URL$HEARTBEAT_KEY?status=up"
echo

# ZFS health
echo "Sending ZFS health"
zpool status -x | grep -q "all pools are healthy" && curl "$API_URL$ZFS_KEY?status=up&msg=ZFS%20Healthy" || curl -G --data-urlencode "status=down" --data-urlencode "msg=$(zpool status -x)" "$API_URL$ZFS_KEY"
echo

# Disk usage
echo "Sending disk usage"
DISKSOK=1
USAGES=()
while read -r output;
do
  partition=$(echo "$output" | awk '{ print $2 }')
  percent=$(echo "$output" | awk '{ print $1 }' | cut -d'%' -f1)
  if [ $percent -ge $DISK_FULL_ALERT_PERCENT_THRESHOLD ]; then
    USAGES+="$partition: $percent%"
    DISKSOK=0
  fi
done <<< $(df | grep -vE "^Filesystem|tmpfs|cdrom" | awk '{ print $5 " " $1 }')
USAGETEXT=$(IFS=,; echo "${USAGES[*]}")
echo $USAGETEXT
if [[ "$DISKSOK" == 1 ]]; then
  curl "$API_URL$DISK_KEY?status=up"
  echo
else
  curl -G --data-urlencode "status=down" --data-urlencode "msg=$USAGETEXT" "$API_URL$DISK_KEY"
  echo
fi