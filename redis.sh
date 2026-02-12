#!/bin/bash

source ./common.sh

app_name=redis
check_root

echo "$(date "+%Y-%m-%d %H:%M:%S") | Disabling other versions of Redis"
dnf module disable redis -y &>>$LOGS_FILE
VALIDATE $? "Disabling other versions of Redis"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Enabling V.7 of Redis"
dnf module enable redis:7 -y &>>$LOGS_FILE
VALIDATE $? "Enabling V.7 of Redis"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Installing Redis"
dnf install redis -y &>>$LOGS_FILE
VALIDATE $? "Installing Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Allowing remote connections"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Enabling Redis Server"
systemctl enable redis &>>$LOGS_FILE
VALIDATE $? "Enabling Redis Server"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Starting Redis Server"
systemctl start redis &>>$LOGS_FILE
VALIDATE $? "Starting Redis Server"

print_total_time