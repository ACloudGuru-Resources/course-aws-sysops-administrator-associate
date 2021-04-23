#!/bin/bash 
echo "creating IAM Role 'MyAutomationRole' for auto remediation rule"
iamRoleArn=$(aws iam create-role --role-name "MyAutomationRole" \
--assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com",
                    "ssm.amazonaws.com"
                ]
            },
            "Action": [
                "sts:AssumeRole"
            ]
        }
    ]
}' --query "Role.Arn" --output=text)
aws iam attach-role-policy --role-name "MyAutomationRole" \
 --policy-arn "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"
aws iam put-role-policy --role-name "MyAutomationRole" \
 --policy-name "AllowPassRole" \
 --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "'$iamRoleArn'"
        }
    ]
}'
