#!/bin/bash

# Start D-Bus daemon
mkdir -p /var/run/dbus
rm -rf /var/run/dbus/pid
dbus-daemon --system

# Initiate the  time machine daemons
chown -R timemachine:timemachine /timemachine
service avahi-daemon start
netatalk -F /usr/local/etc/afp.conf

/bin/bash