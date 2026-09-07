#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"


LOGS_DIR=/home/ec2-user/app-logs
LOGS_FILE="$LOGS_DIR/$0.log"

if [ ! -d $LOGS_DIR ]; then
     echo -e "$LOGS_DIR does not exist"
     exit 1
fi

FILES_TO_DELETE=$(find "$LOGS_DIR" -name "*.log" -mtime +14)

#echo "$FILES_TO_DELETE"

while IFS= read -r filepath; do
     echo "deleting file :: $filepath"
     rm -f "$filepath"
     echo "deleted file :: $filepath"
    done <<< $FILES_TO_DELETE

#  while IFS= read -r filepath; do
#       # Process each line here
#       echo "Deleting file: $filepath"
#       rm -f $filepath
#       echo "Deleted file: $filepath"
#     done <<< $FILES_TO_DELETE