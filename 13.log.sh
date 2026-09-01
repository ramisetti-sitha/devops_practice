#!/bin/bash

USER_ID=$(id -u)
logs_folder="/var/log/shell_script"
logs_file="/var/log/shell_script/$0.log"

if [ $USER_ID -ne 0 ]; then
    echo "please get root user access" | tee -a $logs_file
    exit 1
fi

mkdir -p $logs_folder

VALIDATE(){
    if [ $1 -ne 0 ]; then
       echo "$2 installing.....failure" |tee -a $logs_file
       exit 1
    else
       echo "$2 installing.....success" |tee -a $logs_file
}

dnf install nginx -y
VALIDATE $? NGINX
dnf install nodejs -y
VALIDATE $? NODEJS

