#!/bin/bash
mkdir -p /var/run/dbus
rm -rf /var/run/dbus/pid
dbus-daemon --system
service avahi-daemon start
service netatalk start