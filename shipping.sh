#!/bin/bash

source ./common.sh
app_name=shipping

check_root

app_setup

java_setup

systemd_setup

echo "Installing MySQL client"
dnf install mysql -y &>>$LOGS_FILE
VALIDATE $? "Installing MySQL client"

#we have toi check before loading the data -  check if a schema exists or not 

mysql -h mysql.nemani.online -uroot -pRoboShop@1 -e 'use cities' #logins and checks if cities exists or not

if [ $? -eq 0 ]; then
    echo -e "data is already loaded $Y Skipping $N"
else
    echo "Loading the data"

    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOGS_FILE


    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql  &>>$LOGS_FILE


    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOGS_FILE

    VALIDATE $? "Loading the data"

fi

app_restart

print_total_time