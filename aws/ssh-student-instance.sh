#!/bin/sh

. `dirname $0`/env.sh

KEYFILE=`dirname $0`/${ODS_KEYPAIR_STUDENT}.pem
SHORTNAME=$1

chmod 600 $KEYFILE
ssh -i $KEYFILE -l ubuntu ${SHORTNAME}.${ODS_DOMAIN_NAME}
