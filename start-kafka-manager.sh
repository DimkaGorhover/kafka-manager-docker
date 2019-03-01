#!/usr/bin/env bash

if [[ $KM_HOME = '' ]]; then 
	KM_HOME=$(pwd)
fi

if [[ $ZK_HOSTS = '' ]]; then 
	echo "ZK_HOSTS env is not specified"
	exit 1
fi

KM_CONFIGFILE=$KM_HOME/conf/application.conf

if [[ $KM_USERNAME != ''  && $KM_PASSWORD != '' ]]; then
    sed -i.bak '/^basicAuthentication/d' $KM_CONFIGFILE
    echo 'basicAuthentication.enabled=true' >> $KM_CONFIGFILE
    echo "basicAuthentication.username=${KM_USERNAME}" >> $KM_CONFIGFILE
    echo "basicAuthentication.password=${KM_PASSWORD}" >> $KM_CONFIGFILE
    echo 'basicAuthentication.realm="Kafka-Manager"' >> $KM_CONFIGFILE
fi

exec $KM_HOME/bin/kafka-manager -Dconfig.file=${KM_CONFIGFILE} "${KM_ARGS}" "${@}"