#!/bin/bash
app_name=catalogue

source ./common.sh

check_root

app_setup

nodejs_setup

systemd_setup

#Loading data into MongoDB

echo "$(date "+%Y-%m-%d %H:%M:%S") | Copying Mongo Repo"
cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGS_FILE
VALIDATE $? "Copying Mongo Repo"

echo "$(date "+%Y-%m-%d %H:%M:%S") | Installing Mongo Client"
dnf install mongodb-mongosh -y &>>$LOGS_FILE
VALIDATE $? "Installing Mongo Client"


INDEX=$(mongosh --host $MONGODB_HOST --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $INDEX -le 0 ]; then
    echo "$(date "+%Y-%m-%d %H:%M:%S") | the database is not loaded so Loading products now"
    mongosh --host $MONGODB_HOST  </app/db/master-data.js  &>>$LOGS_FILE
    VALIDATE $? "Loading products"
else
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Products already loaded $Y SKIPPING$N"
fi

app_restart

print_total_time