#!/bin/bash

user_id=$(id -u)
logs_folder="/var/log/catalogue"
logs_file="${logs_folder}/${0}.log"
domain_name="vishaldevops.store"
scripts_dir=$($dirname "$(realpath "$0")")
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

dnf module disable nodejs -y &>> $logs_file
dnf module enable nodejs:24 -y &>> $logs_file
dnf install nodejs -y &>> $logs_file
validate $? "installing nodejs24"

node -v
validate $? "checking version"

id roboshop &>> $logs_file

if [ $> -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $logs_file
    validate $? "creating system user"
else
    echo -e "$(timestamp) [INFO] system user roboshop already existis....${Y}SKIPPING${N}"
fi

mkdir -p /app
validate $? "creating app directory"

curl -L -o /tmp/catalogue.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/catalogue-v4.zip &>> $logs_file
validate $? "downloading catalogue"

cd /app
unzip /tmp/catalogue.zip &>> $logs_file
validate $? "Unzipping catalogue"

cd /app
npm install &>> $logs_file
validate $? "Installing dependencies"

sed -i 's/DOMAIN_NAME/$domain_name' "$scripts_dir/catalogue.service" &>> $logs_file

cp catalogue.service /etc/systemd/system/catalogue.service &>> $logs_file
validate $? "validating catalogue.service"

systemctl daemon-reload &>> $logs_file
systemctl enable catalogue &>> $logs_file
systemctl start catalogue &>> $logs_file
validate $? " enabling and starting the catalogue service"


echo "$(timestamp) [INFO] Script Comopleted in $SECONDS seconds"
echo "$(timestamp) [INFO] Script Complted Execution ==========" | tee -a $logs_file