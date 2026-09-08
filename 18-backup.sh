#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-script"
LOGS_FILE="$LOGS_FOLDER/backup.log"
SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14}
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"


log(){
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $1" | tee -a $LOGS_FILE
}

if [ $USERID -ne 0 ]; then
    log "$R Please run this script with root user access $N"
    exit 1
fi

mkdir -p $LOGS_FOLDER

USAGE(){
    log "$R USAGE::sudo backup <SOURCE_DIR> <DEST_DIR> <DAYS>[Default 14 days] $N"
    exit 1
}

if [ $# -lt 2 ]; then
    USAGE
fi

if [ ! -d $SOURCE_DIR ]; then
    log "$R SOURCE DIRECTORY::$SOURCE_DIR does not exit $N"
    exit 1
fi

if [ ! -d $DEST_DIR ]; then 
    log "$R DESTINATION DIRECTORY ::$DEST_DIR does not exist $N"
    exit 1
fi

FILES=$(find $SOURCE_DIR -name "*.log" -type f -mtime +$DAYS)

log "BACKUP STARTED"
log "SOURCE DIRECTORY:: $SOURCE_DIR"
log "DESTINATION DIRECTORY :: $DEST_DIR"
log "NUMBER OF DAYS :: $DAYS"

