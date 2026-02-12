#!/bin/bash

source ./common.sh
app_name=frontend

check_root

echo "$(date "+%Y-%m-%d %H:%M:%S") | Disabling other versions of Nginx"
dnf module disable nginx -y &>>$LOGS_FILE
VALIDATE $? "Disabling other versions of Nginx"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Enabling V1.24 of Nginx"
dnf module enable nginx:1.24 -y &>>$LOGS_FILE
VALIDATE $? "Enabling V1.24 of Nginx"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Installing Nginx"
dnf install nginx -y &>>$LOGS_FILE
VALIDATE $? "Installing Nginx"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Enabling Nginx"
systemctl enable nginx &>>$LOGS_FILE
VALIDATE $? "Enabling Nginx"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Starting Nginx"
systemctl start nginx &>>$LOGS_FILE
VALIDATE $? "Starting Nginx"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Removing exixiting defailt HTML code"
rm -rf /usr/share/nginx/html/* &>>$LOGS_FILE
VALIDATE $? "Removing exixiting  HTML code"

echo "$(date "+%Y-%m-%d %H:%M:%S") |Downloading Front-end"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOGS_FILE
VALIDATE $? "Downloading Front-end"

echo "$(date "+%Y-%m-%d %H:%M:%S") | opening directtory and unzipping"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? "opening directtory and unzipping"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Force removinf the ecisiting conf file"
rm -rf /etc/nginx/nginx.conf
VALIDATE $? "Force removinf the ecisiting conf file"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Copying our modified nginx conf filr"
cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copying our modified nginx conf filr"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Restarting Nginx"
systemctl restart nginx
VALIDATE $? "Restarting Nginx"

print_total_time