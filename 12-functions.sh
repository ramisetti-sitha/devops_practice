#!/bin/bash

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ]; then
    echo "please get access of root"
    exit 1
fi
VALIDATE(){
if [ $1 -ne 0 ]; then
    echo "$2 installing ....failure"
    exit 1
else
    echo "$2 installing....success"
fi
}


dnf install nginx -y
VALIDATE $? NGINX

dnf install mysql -y
VALIDATE $? MYSQL
