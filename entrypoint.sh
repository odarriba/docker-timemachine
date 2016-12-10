#!/bin/bash

set -e

mkdir -p /conf.d/netatalk

# Need to initialize?
if [ ! -e /.initialized ]; then
    if [ -z $AFP_LOGIN ]; then
        echo "no AFP_LOGIN specified!"
        exit 1
    fi

    if [ -z $AFP_PASSWORD ]; then
        echo "no AFP_PASSWORD specified!"
        exit 1
    fi

    if [ -z $AFP_NAME ]; then
        echo "no AFP_NAME specified!"
        exit 1
    fi

    # Add the user
    addgroup $AFP_LOGIN
    adduser -S -H -G $AFP_LOGIN $AFP_LOGIN
    echo $AFP_LOGIN:$AFP_PASSWORD | chpasswd

    echo "[Global]
	mimic model = Xserve
	log file = /var/log/afpd.log
	log level = default:warn
	zeroconf = no

[${AFP_NAME}]
	path = /timemachine
	time machine = yes
	valid users = ${AFP_LOGIN}" >> /etc/afp.conf

    if [ -n "$AFP_SIZE_LIMIT" ]; then
        echo "
	vol size limit = ${AFP_SIZE_LIMIT}" >> /etc/afp.conf
    fi

    touch /.initialized
fi

# Initiate the timemachine daemons
chown -R $AFP_LOGIN:$AFP_LOGIN /timemachine

# Clean out old locks
/bin/rm -f /var/lock/netatalk

if [ ! -e /var/run/dbus/system_bus_socket ]; then
	dbus-daemon --system
fi

avahi-daemon -D
exec netatalk -d
