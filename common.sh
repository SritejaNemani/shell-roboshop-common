 #!/bin/bash

USER_ID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m" #red
G="\e[32m" #green
Y="\e[33m" #yellow
N="\e[0m" #normal-white
SCRIPT_DIR=$PWD
START_TIME=$(date +%s)
MONGODB_HOST=mongodb.nemani.online

echo "$(date "+%Y-%m-%d %H:%M:%S") | Script started executing at: $(date)" | tee -a $LOGS_FILE

check_root() {

    if [ $USER_ID -ne 0 ]; then
    echo -e "$R Not root user - please run this script with root user$N" | tee -a $LOGS_FILE
    exit 1 #if we dont give this Even if there is an error the script executes the next lines as well. In order to prevent this we exit with any failure code generally 1
    fi
}

mkdir -p $LOGS_FOLDER


VALIDATE(){
   if [ $1 -ne 0 ]; then    #here $1 -- 1st arg is $? - exit status of prev command
      echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 $R Failure $N" | tee -a $LOGS_FILE # $2 2nd arg is Insatll nginx(package)
      exit 1 # here if it is one installation like prev screipt exiit 1 isn't required but here if we don'r exit the script will continue with next installations which may lead to problem
   else 
      echo -e "$(date "+%Y-%m-%d %H:%M:%S") |$2 $G Success $N" | tee -a $LOGS_FILE
   fi
}

nodejs_setup(){

    echo "Disabling other versions of Nodejs"
    dnf module disable nodejs -y &>>$LOGS_FILE
    VALIDATE $? "Disabling other versions of Nodejs"

    echo "Enabling V.20 of NodeJS"
    dnf module enable nodejs:20 -y &>>$LOGS_FILE
    VALIDATE $? "Enabling V.20 of NodeJS"

    echo "Installing NodeJS"
    dnf install nodejs -y &>>$LOGS_FILE
    VALIDATE $? "Installing NodeJS"

    cd /app 

    echo "Installing Dependencies"
    npm install &>>$LOGS_FILE
    VALIDATE $? "Installing Dependencies"

}

app_setup(){

    id roboshop &>>$LOGS_FILE
    if [ $? -eq 0 ]; then
        echo -e " Roboshop user already exists - $Y skipping to create new user again$N" 
    else
        echo "Creating Sysytem User"
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
        VALIDATE $? "Creating Sysytem User"
    fi

    echo "Creating App Directory"
    mkdir -p /app &>>$LOGS_FILE
    VALIDATE $? "Creating App Directory"

    echo "Downloading $appname code"
    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOGS_FILE
    VALIDATE $? "Downloading catalog code"

    echo "Opening app Directory"
    cd /app 
    VALIDATE $? "Opening app Directory"

    echo "Removing all existing files in App directory"
    rm -rf /app/* &>>$LOGS_FILE
    VALIDATE $? "Removing all existing files in App directory"

    echo "Unzipping the downloaded code"
    unzip /tmp/$app_name.zip &>>$LOGS_FILE
    VALIDATE $? "Unzipping the downloaded code"
}

systemd_setup(){
    
    echo "Creating Systemctl Service"
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>>$LOGS_FILE
    VALIDATE $? "Creating Systemctl Service"

    echo "Loading the Service"
    systemctl daemon-reload &>>$LOGS_FILE
    VALIDATE $? "Loading the Service"

    echo "Enabling $app_name Server"
    systemctl enable $app_name &>>$LOGS_FILE
    VALIDATE $? "Enabling $app_name Server"

    echo "Starting $app_name Server"
    systemctl start $app_name &>>$LOGS_FILE
    VALIDATE $? "Starting Catalogue Server"

}

print_total_time(){

    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME - $START_TIME))
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script executed in $G $TOTAL_TIME seconds $N" | tee -a $LOGS_FILE
}