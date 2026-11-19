#!/bin/bash

user_id=$(id -u)
logs_folder="/var/log/catalogue"
logs_file="${logs_folder}/${0}.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $user_id -ne 0 ]; then
    echo "Please run this script with sudo access.."
    exit 1
fi

mkdir -p $logs_folder

echo "Script started execution at $(date +"%F %T")" &>> $logs_file

timestamp(){
    date +"%F %T"
}

validate(){
    if [ $1 -ne 0 ]; then
        echo -e "$(timestamp) [ERROR] ${2}..${R}FAILED${N}" | tee -a $logs_file
        exit 1
    else
        echo -e "$(timestamp) [INFO] ${2}..${G}SUCCESS${N}" | tee -a $logs_file
    fi
}

echo "$(timestamp) [INFO] Script Started Execution ==========" | tee -a $logs_file

dnf module disable nodejs -y
dnf module enable nodejs:24 -y
dnf install nodejs -y
validate $? "installing nodejs24"

node -v
validate $? "checking version"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
validate $? "creating system user"


echo "$(timestamp) [INFO] Script Comopleted in $SECONDS seconds"
echo "$(timestamp) [INFO] Script Complted Execution ==========" | tee -a $logs_file