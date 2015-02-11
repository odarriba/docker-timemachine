#!/bin/bash

set -e

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
    useradd $AFP_LOGIN -M
    echo $AFP_LOGIN:$AFP_PASSWORD | chpasswd

    echo "[Global]
	mimic model = Xserve
	log file = /var/log/afpd.log
	log level = default:warn

[${AFP_NAME}]
    path = /timemachine
    time machine = yes
    valid users = ${AFP_LOGIN}" >> /usr/local/etc/afp.conf

    if [ -n $AFP_SIZE_LIMIT ]; then
        echo "
	vol size limit = ${AFP_SIZE_LIMIT}" >> /usr/local/etc/afp.conf
    fi

    touch /.initialized
fi

# Start D-Bus daemon
mkdir -p /var/run/dbus
rm -rf /var/run/dbus/pid
dbus-daemon --system

# Initiate the  time machine daemons
chown -R $AFP_LOGIN:$AFP_LOGIN /timemachine
service avahi-daemon start
netatalk -F /usr/local/etc/afp.conf

/bin/bash