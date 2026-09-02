USER_ID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
SCRIPT_DIR="$PWD"
MONGODB_HOST="mongodb.devdaws.site"

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

dnf module disable nodejs -y &>> $LOGS_FILE
VALIDATE $? "disabling default version of nodejs"

dnf module enable nodejs:20 -y &>> $LOGS_FILE
VALIDATE $? "enabling 20th version of nodejs"

dnf install nodejs -y &>> $LOGS_FILE
VALIDATE $? "installing nodejs"

id roboshop &>> $LOGS_FILE

if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOGS_FILE
    VALIDATE $? "creating system user"
else
    echo -e "rorboshop user is existing... $Y SKIPPING $N" 

fi

mkdir -p /app
VALIDATE $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE $? "downloading catalogue code"

cd /app
VALIDATE $? "moving to app directory"

rm -rf /app/*
VALIDATE $? "removing if their is code in app directory"

unzip /tmp/catalogue.zip
VALIDATE $? "unzipping the code"

npm install &>> $LOGS_FILE
VALIDATE $? "installing dependencies"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "copying the service code of systemctl"

systemctl daemon-reload 
systemctl enable catalogue
systemctl start catalogue
VALIDATE $? "starting and enabling catalogue"

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying"


dnf install mongodb-mongosh -y

INDEX=$(mongosh --host $MONGODB_HOST --quiet --eval 'db.getMongo().getDBNames().indexof("catalogues")')
       if [ $INDEX -le 0 ]; then
          mongosh --host $MONGODB_HOST </app/db/master-data.js
          VALIDATE $? "loading data"
        else
           echo -e "products already loaded $Y Skipping $N"

        fi
systemctl restart catalogue
VALIDATE $? "reastarting catalogue service"
