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

# Clean out old locks
/bin/rm -f /var/lock/netatalk

rm -rf /var/run/avahi-daemon/*

if [ -e /var/run/dbus/system_bus_socket ]; then
    rm -rf /var/run/avahi-daemon/pid
fi

if [ ! -e /var/run/dbus/system_bus_socket ]; then
    dbus-daemon --system
fi

avahi-daemon -D
exec netatalk -d
