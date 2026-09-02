#!/bin/bash

SG_ID="sg-07b728a2bc1308355"
AMI_ID="ami-0220d79f3f480ecf5"
for instance in $@
do
   instance_id=$(
     aws ec2 run-instances \
     --image-id $AMI_ID \
     --instance-type "t3.micro" \
     --security-group-ids $SG_ID \
     --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
     --query 'Instance[0].InstanceId' \
     --output text
   )
   if [ $instance == "frontend" ]; then
       IP=$(
        aws ec2 describe-instances \
        --instance-ids $instance_id \
        --query "Resevations[].Instances[].PublicIPAddress" \
        --output text
       )
    else
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $instance_id \
            --query "Reservations[].Instances[].PrivateIPAddress" \
            --output text
        )
    fi
    echo "IP ADDRESS::$IP"
done
    