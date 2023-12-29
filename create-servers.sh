#!/bin/bash

NAME=$@
INSTANCE_TYPE=""
IMAGE_ID=ami-03265a0778a880afb
SECURITY_GROUP_ID=sg-001887f7841106c09
#DOMAIN_NAME=sivadevops.website

for i in $@
do
 if [ $i == 'mongodb' || $i == 'mysql' ]
  then
     INSTANCE_TYPE="t3.medium"
  else
     INSTANCE_TYPE="t2.medium"
 fi
 echo creating $i instance
 aws ec2 run-instances --image-id $IMAGE_ID  --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID 
 echo "created $i instance: $IP_ADDRESS"
done