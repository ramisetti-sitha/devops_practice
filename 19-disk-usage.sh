#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MESSAGE=""
IP_ADDRESS=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
DISK_USAGE=$(df -hT |grep -v Filesystem)
USAGE_THRESHOLD=3
while IFS= read -r line
do
  USAGE=$(echo $line| awk '{print $6}'|cut  -d '%' -f1)
  PARTITION=$(echo $line | awk '{print $7}'|cut  -d '%' -f1)
if [ $USAGE -ge $USAGE_THRESHOLD ]; then
    MESSAGE+="High Disk usage on $PARTITION: $USAGE% <br>"
fi
done <<< $DISK_USAGE

echo -e "$MESSAGE"