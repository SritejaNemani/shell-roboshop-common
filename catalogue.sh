#!/bin/bash
app_name=catalogue

source ./common.sh

check_root

app_setup

nodejs_setup

systemd_setup

#Loading data into MongoDB

echo "Copying Mongo Repo"
cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGS_FILE
VALIDATE $? "Copying Mongo Repo"

echo "Installing Mongo Client"
dnf install mongodb-mongosh -y &>>$LOGS_FILE
VALIDATE $? "Installing Mongo Client"


INDEX=$(mongosh --host $MONGODB_HOST --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $INDEX -le 0 ]; then
    echo "the database is not loaded so Loading products now"
    mongosh --host $MONGODB_HOST  </app/db/master-data.js  &>>$LOGS_FILE
    VALIDATE $? "Loading products"
else
    echo -e "Products already loaded $Y SKIPPING$N"
fi

echo "Restarting Catalogue Server"
systemctl restart catalogue &>>$LOGS_FILE
VALIDATE $? "Restarting Catalogue Server"