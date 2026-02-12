#!/bin/bash

source ./common.sh
app_name=mysql

check_root

echo "$(date "+%Y-%m-%d %H:%M:%S") |Installing MySQL Server"
dnf install mysql-server -y &>>$LOGS_FILE
VALIDATE $? "Installing MySQL Server"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Enabling MySQL Server"
systemctl enable mysqld &>>$LOGS_FILE
VALIDATE $? "Enabling MySQL Server"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Starting MySQL Server"
systemctl start mysqld &>>$LOGS_FILE
VALIDATE $? "Starting MySQL Server"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Setting root password"
mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Setting root password"

print_total_time