#!/bin/sh


if [ ! -f /conf/aria2.conf ]; then
    cp /etc/aria2/aria2.conf /conf/aria2.conf

    if [ ! "$SECRET" ]; then
        "${SECRET}"="E9pY8ptiyUIqmHUlKgG9gK/xcwmADsSWuYb9AS7tI8Y="
    fi
    echo "rpc-secret=${SECRET}" >> /conf/aria2.conf
fi
if [ ! -f /conf/on-complete.sh ]; then
    cp /etc/aria2/on-complete.sh /conf/on-complete.sh
fi

chmod +x /conf/on-complete.sh
touch /conf/aria2.session

aria2c --conf-path=/conf/aria2.conf
