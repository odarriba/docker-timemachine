#!/bin/bash

set -e

mkdir -p /conf.d/netatalk

if [ ! -e /.initialized_afp ]; then
    rm /etc/afp.conf

    echo "[Global]
    mimic model = Xserve
    log file = /var/log/afpd.log
    log level = default:warn
    zeroconf = no" >> /etc/afp.conf

    touch /.initialized_afp
fi

if [ ! -e /.initialized_user ] && [ ! -z $AFP_LOGIN ] && [ ! -z $AFP_PASSWORD ] && [ ! -z $AFP_NAME ]; then
    add-account $AFP_LOGIN $AFP_PASSWORD $AFP_NAME /timemachine $AFP_SIZE_LIMIT
    touch /.initialized_user
fi

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
