#!/bin/bash

ami_id="ami-0055977a6e828a4f4"
instance_type="t3.micro"
domain_name="vishaldevops.store"
hosted_zone_id="Z00703867S0ODMRX3ZHF"

for instance in $@
do

    echo "creating instance: $instance"
# aws ec2 run-instances \
#     --image-id ami-0055977a6e828a4f4 \
#     --instance-type t3.micro \
#     --security-groups "roboshop-common" \
# 	--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=roboshop-shell}]' \
# 	--query 'Instances[0].InstanceId' \
#     --output text

done
