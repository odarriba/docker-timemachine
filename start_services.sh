#!/bin/bash

# Start D-Bus daemon
mkdir -p /var/run/dbus
rm -rf /var/run/dbus/pid
dbus-daemon --system

# Change the machine's hostname
sudo hostname timemachine

# Initiate the  time machine daemons
chown -R timemachine:timemachine /timemachine
service avahi-daemon start
service netatalk start