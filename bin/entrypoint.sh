#!/bin/bash

set -e

if [ ! -e /.initialized_user ] && [ ! -z "$AFP_LOGIN" ] && [ ! -z "$AFP_PASSWORD" ] && [ ! -z "$AFP_NAME" ] && [ ! -z $PUID ] && [ ! -z $PGID ]; then
    add-account -i $PUID -g $PGID "$AFP_LOGIN" "$AFP_PASSWORD" "$AFP_NAME" /timemachine
    touch /.initialized_user
fi

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
