#!/bin/bash
echo "Creating our IAM Role 'MyAutomationRole', required for AWS Config auto remediation"
echo "Attaching the the AmazonSSMAutomationRole AWS Managed Policy..."
#This command creates our role and configures a trust policy which allows EC2 and Systems Manager to assume the role.
echo "Creating the role and configuring the Trust Policy, to allow EC2 and Systems Manager to assume this role..."
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

#This command attaches the AmazonSSMAutomationRole AWS Managed Policy 
echo "Attaching the the AmazonSSMAutomationRole AWS Managed Policy..."
aws iam attach-role-policy --role-name "MyAutomationRole" \
 --policy-arn "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"

#This command adds the inline policy which allows the role to be passed to another service. We have to pass in the ARN of our role. 
echo "Adding the inline policy which allows the role to be passed to another service..."
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
#Finally, we'll output the ARN of the role we created
echo $iamRoleArn
