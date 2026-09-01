#!/bin/bash

set -e



R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

USER_ID=$(id -u)
logs_folder="/var/log/shell_script"
logs_file="/var/log/shell_script/$0.log"

if [ $USER_ID -ne 0 ]; then
    echo  -e "$B please get root access $N" |tee -a $logs_file
    exit 1
fi



for package in $@
do 
  dnf list installed $package -y &>> $logs_file

  if [ $? -ne 0 ]; then
    echo "$package not installed,install now"
    dnf install $package -y &>> $logs_file
 
else 
    echo -e "$package is already installed, $Y skipping $N"
fi
done
