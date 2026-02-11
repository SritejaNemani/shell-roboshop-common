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
#MONGODB_HOST=mongodb.nemani.online

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

print_total_time(){

    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME - $START_TIME))
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script executed in $G $TOTAL_TIME seconds $N" | tee -a $LOGS_FILE
}