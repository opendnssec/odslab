#!/bin/sh
#
# Create student instances

. `dirname $0`/env.sh

export PAGER=cat
AWS="aws --profile ${ODS_AWS_PROFILE} --region ${ODS_EC2_REGION}"

for TYPE in resolver signer; do
	RUNFILE=/tmp/ec2-student-${TYPE}.$$.tmp

	#cloud-config
	#hostname: mynode
	#fqdn: mynode.example.com
	#manage_etc_hosts: true

	## create all instances
	${AWS} ec2 run-instances \
		--count ${ODS_STUDENT_COUNT} \
		--instance-type ${ODS_EC2_TYPE} \
		--image-id ${ODS_EC2_AMI} \
		--subnet-id ${ODS_EC2_SUBNET_ID} \
		--security-group-ids ${ODS_EC2_SG_ID} \
		--key-name ${ODS_KEYPAIR_STUDENT} \
		> ${RUNFILE}

	# find instance IDs
	INSTANCES=`jq -r '.Instances[].InstanceId' < ${RUNFILE}`

	# set tags on all instances
	i=0
	for INSTANCE in $INSTANCES; do
		echo "Tagging student instance ${INSTANCE} (type ${TYPE})"
		i=`expr $i + 1`
		NAME=${TYPE}${i}	
		TAG="[ { \"Key\": \"Name\", \"Value\": \"${NAME}\" },
		       { \"Key\": \"Type\", \"Value\": \"${TYPE}\" },
		       { \"Key\": \"ID\", \"Value\": \"${i}\" } ]"
		${AWS} ec2 create-tags --resources $INSTANCE --tags "${TAG}"
	done

	# clean up temporary files
	rm -f ${RUNFILE}
done
