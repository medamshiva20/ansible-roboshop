#!/bin/bash

NAME=$@
INSTANCE_TYPE=""
IMAGE_ID=ami-03265a0778a880afb
SECURITY_GROUP_ID=sg-001887f7841106c09
DOMAIN_NAME=sivadevops.website


# if mysql or mongodb instance_type should be t3.medium , for all others it is t2.micro
for i in $@
do
 if [[ $i == "mongodb" || $i == "mysql" ]]
  then
     INSTANCE_TYPE="t3.medium"
  else
     INSTANCE_TYPE="t2.micro"
 fi
 echo creating $i instance
 IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID  --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications 'ResourceType=instance,Tags=[{Key=webserver,Value=$i}]' | jq -r '.Instances[0].PrivateIpAddress')
 echo "created $i instance: $IP_ADDRESS"
 #To assign tag specifications to the ec2 instance --> https://serverfault.com/questions/724501/how-to-add-a-tag-when-launching-an-ec2-instance-using-aws-clis
 
 #https://repost.aws/knowledge-center/simple-resource-record-route53-cli -- To create the route 53 records through AWS CLI
 aws route53 change-resource-record-sets --hosted-zone-id Z02130291L9UW40NZZ0BT --change-batch  '
    {
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                            "Name": "'$i.$DOMAIN_NAME'",
                            "Type": "A",
                            "TTL": 300,
                            "ResourceRecords": [{ "Value": "'$IP_ADDRESS'"}]
                        }}]
    }
    '
done