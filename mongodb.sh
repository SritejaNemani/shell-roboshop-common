#!/bin/bash

source ./common.sh

check_root

echo "$(date "+%Y-%m-%d %H:%M:%S") | Copying Mongo Repo"
cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying Mongo Repo"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Installing MongoDB Server"
dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "Installing MongoDB Server"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Enabling MongoDB Server"
systemctl enable mongod &>>$LOGS_FILE
VALIDATE $? "Enabling MongoDB Server"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Starting MongoDB Server"
systemctl start mongod &>>$LOGS_FILE
VALIDATE $? "Starting MongoDB Server"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing remote connections"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Restarting MongoDB Server"
systemctl restart mongod 
VALIDATE $? "Restarting MongoDB Server"

print_total_time
