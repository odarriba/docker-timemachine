#!/bin/bash

set -e

mkdir -p /conf.d/netatalk

if [ ! -e /etc/afp.conf ]; then
    echo "[Global]
    mimic model = Xserve
    log file = /var/log/afpd.log
    log level = default:warn
    zeroconf = no" >> /etc/afp.conf
fi

if [ ! -e /.initialized ] && [ ! -z $AFP_LOGIN ] && [ ! -z $AFP_PASSWORD ] && [ ! -z $AFP_NAME ]; then
    add-account $AFP_LOGIN $AFP_PASSWORD $AFP_NAME $AFP_SIZE_LIMIT
    touch /.initialized
fi

# Clean out old locks
/bin/rm -f /var/lock/netatalk

if [ ! -e /var/run/dbus/system_bus_socket ]; then
    dbus-daemon --system
fi

netatalk -d