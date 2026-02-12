#!/bin/bash

source ./common.sh
app_name=rabbitmq

check_root

echo "$(date "+%Y-%m-%d %H:%M:%S") | Adding RabbitMQ repo"
cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "Adding RabbitMQ repo"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Installing RabbitMQ"
dnf install rabbitmq-server -y &>>$LOGS_FILE
VALIDATE $? "Installing RabbitMQ"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Enabling RabbitMQ Server"
systemctl enable rabbitmq-server &>>$LOGS_FILE
VALIDATE $? "Enabling RabbitMQ Server"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Starting RabbitMQ Server"
systemctl start rabbitmq-server &>>$LOGS_FILE
VALIDATE $? "Starting RabbitMQ Server"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Creating User and giving Permisiions"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "Creating User and giving Permisiions"

print_total_time