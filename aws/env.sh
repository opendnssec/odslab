# AWS Command Line Interface Profile
export ODS_AWS_PROFILE=default

# Lab domain name
export ODS_DOMAIN_NAME=odslab.se

# AWS Region
export ODS_EC2_REGION=eu-west-1

# SSH Key Pairs
export ODS_KEYPAIR_STUDENT="ods-student-20180418"

# Maximum is currently 90 groups (180 instances)
# More can be requested here:
# http://aws.amazon.com/contact-us/ec2-request/
export ODS_STUDENT_COUNT=1

# Network settings
export ODS_EC2_SG_ID=sg-14a9fd72
export ODS_EC2_VPC_ID=vpc-87a187e3
export ODS_EC2_SUBNET_ID=subnet-eaf785b2

# update with latest 64-bit EBS AMI from https://cloud-images.ubuntu.com/locator/ec2/
# (search for "eu-west amd64 ebs hvm")
export ODS_EC2_AMI=ami-74e6b80d
export ODS_EC2_TYPE=t2.micro
