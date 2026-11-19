#!/bin/bash

user_id=$(id -u)
logs_folder="/var/log/msql"
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

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
validate $? "Adding rabbitmq repo"

dnf install erlang rabbitmq-server -y &>> $logs_file
validate $? "Installing rabbitmq server"

systemctl enable rabbitmq-server &>> $logs_file
systemctl start rabbitmq-server &>> $logs_file
validate $? "Enabling and staring rabbit mq"

rabbitmqctl list_users | grep -qw "roboshop"
if [ $? -ne 0 ]; then
    rabbitmqctl add_user roboshop roboshop123
    validate $? "creating rabbitmq user for roboshop"
else
    echo -e "$(timestamp) [INFO] RabbitMq user already exist....${Y}SKIPPING${N}"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
validate $? "Setting up permission for rabbitmq user for robo shop"

echo "$(timestamp) [INFO] Script Comopleted in $SECONDS seconds"
echo "$(timestamp) [INFO] Script Complted Execution ==========" | tee -a $logs_file