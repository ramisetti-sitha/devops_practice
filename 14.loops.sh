#!/bin/bash



R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"

USER_ID=$(id -u)
logs_folder="/var/log/shell_script"
logs_file="/var/log/shell_script/$0.log"

if [ $USER_ID -ne 0 ]; then
    echo "$B please get root access $N" |tee -a $logs_file
    exit 1
fi

VALIDATE(){

    if [ $1 -ne 0 ]; then
       echo "$2 installing..$R failure $N." |tee -a $logs_file
       exit 1
    else
       echo "$2 installing..$G success $N...." |tee -a $logs_file
    fi
}

for package in $@
do 
  dnf list installed $package -y &>> $logs_file

  if [ $? -ne 0 ]; then
    echo "$package not installed,install now"
    dnf install $package -y &>> $logs_file
    VALIDATE $? $package
else 
    echo "$package is already installed,$Y skipping $N"
fi
done
