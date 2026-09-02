#!/bin/bash

USER_ID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

if [ $USER_ID -ne 0 ]; then
    echo -e "$R please run this script with root user $N" | tee -a $LOGS_FILE
    exit 1
fi

mkdir -p $LOGS_FOLDER

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2.... $R FAILURE $N" |tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$2..... $G SUCCESS $N" |tee -a $LOGS_FILE
    fi       
}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying"

dnf install mongodb-org -y &>> $LOGS_FILE
VALIDATE $? "installing mongodb"

systemctl enable mongod &>> $LOGS_FILE
VALIDATE $? "enabling mongodb"

systemctl start mongod &>> $LOGS_FILE
VALIDATE $? "starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "allowing remote control"

systemctl restart mongod
VALIDATE $? "restarting mongodb"