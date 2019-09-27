#!/bin/sh


# 设置GID
# shellcheck disable=SC2006
if [ -n "${USER_GID}" ] && [ "${USER_GID}" != "`id -g "${USER}"`" ]; then
    sed -i -e "s/^${USER}:\([^:]*\):[0-9]*/${USER}:\1:${USER_GID}/" /etc/group
    sed -i -e "s/^${USER}:\([^:]*\):\([0-9]*\):[0-9]*/${USER}:\1:\2:${USER_GID}/" /etc/passwd
fi

## 设置UID
if [ -n "${USER_UID}" ] && [ "${USER_UID}" != "`id -u "${USER}"`" ]; then
    sed -i -e "s/^${USER}:\([^:]*\):[0-9]*:\([0-9]*\)/${USER}:\1:${USER_UID}:\2/" /etc/passwd
fi

if [ ! -f /conf/aria2.conf ]; then
    cp /etc/aria2/aria2.conf /conf/aria2.conf

    if [ ! "$SECRET" ]; then
        "${SECRET}"="E9pY8ptiyUIqmHUlKgG9gK/xcwmADsSWuYb9AS7tI8Y="
    fi
    echo "rpc-secret=${SECRET}" >> /conf/aria2.conf
fi
if [ ! -f /conf/on-complete.sh ]; then
    cp /etc/aria2/shell/on-complete.sh /conf/on-complete.sh
fi

chmod +x /conf/on-complete.sh
touch /conf/aria2.session

python /etc/aria2/shell/aria2.py -c "/conf/aria2.conf" -u "${TRACKER_LIST_URL}" -e "${EXCLUDE_TRACKER_LIST_URL}" &
aria2c --conf-path=/conf/aria2.conf
