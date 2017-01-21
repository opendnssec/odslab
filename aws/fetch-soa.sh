#!/bin/sh

. `dirname $0`/env.sh

COUNT=${ODS_STUDENT_COUNT}

# set tags on all instances
i=$COUNT
while [ $i -gt 0 ]; do
	
	SERVER=ns${i}.${ODS_DOMAIN_NAME}
	DOMAIN=group${i}.${ODS_DOMAIN_NAME}
	
	echo "${DOMAIN}: "`dig +short +time=1 @${SERVER} ${DOMAIN} SOA`
	
	i=`expr $i - 1`
done
