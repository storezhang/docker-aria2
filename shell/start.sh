#!/bin/sh

if [ "${USERNAME}" != "aria2" ]; then
    sed -i -e "s/^aria2\:/${USERNAME}\:/g" /etc/passwd
fi

if [ -z "${GID}" ]; then
  # shellcheck disable=SC2006
  GID="`id -g "${USERNAME}"`"
fi

if [ -z "${UID}" ]; then
  # shellcheck disable=SC2006
  UID="`id -u "${USERNAME}"`"
fi

# 设置GID
# shellcheck disable=SC2006
if [ -n "${GID}" ] && [ "${GID}" != "`id -g "${USERNAME}"`" ]; then
    sed -i -e "s/^${USERNAME}:\([^:]*\):[0-9]*/${USERNAME}:\1:${GID}/" /etc/group
    sed -i -e "s/^${USERNAME}:\([^:]*\):\([0-9]*\):[0-9]*/${USERNAME}:\1:\2:${GID}/" /etc/passwd
fi

## 设置UID
# shellcheck disable=SC2006
if [ -n "${UID}" ] && [ "${UID}" != "`id -u "${USERNAME}"`" ]; then
    sed -i -e "s/^${USERNAME}:\([^:]*\):[0-9]*:\([0-9]*\)/${USERNAME}:\1:${UID}:\2/" /etc/passwd
fi

if [ ! -f /conf/aria2.conf ]; then
    cp /etc/aria2/aria2.conf /conf/aria2.conf

    if [ ! "$SECRET" ]; then
        "${SECRET}"="E9pY8ptiyUIqmHUlKgG9gK/xcwmADsSWuYb9AS7tI8Y="
    fi
    echo "rpc-secret=${SECRET}" >> /conf/aria2.conf
fi
if [ ! -f /conf/config.conf ]; then
    cp /etc/aria2/config.conf /conf/config.conf
fi
if [ ! -f /conf/on-complete.sh ]; then
    cp /etc/aria2/shell/on-complete.sh /conf/on-complete.sh
fi

chmod +x /conf/on-complete.sh
touch /conf/aria2.session

python3 /etc/aria2/shell/aria2.py -c "/conf" &
aria2c --conf-path=/conf/aria2.conf
