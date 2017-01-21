#!/bin/sh

. `dirname $0`/env.sh

COUNT=${ODS_STUDENT_COUNT}

DNSKEY=dnskey.tmp.$$
DS=ds.txt

rm -f $DS

fetch() {
	GROUP=$1

	SERVER=ns${GROUP}.${ODS_DOMAIN_NAME}
	DOMAIN=group${GROUP}.${ODS_DOMAIN_NAME}

	echo "Fetching DS for ${DOMAIN} ..." >&2
	dig +time=1 @${SERVER} ${DOMAIN} DNSKEY >${DNSKEY}
	ldns-key2ds -n $DNSKEY >> $DS
	rm -f ${DNSKEY}
}

if [ -n "$1" ]; then
	fetch $1
else
	i=$COUNT
	while [ $i -gt 0 ]; do
		fetch $i
		i=`expr $i - 1`
	done
fi

cat $DS | sort
