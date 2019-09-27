FROM storezhang/alpine

MAINTAINER storezhang "storezhang@gmail.com"
LABEL architecture="AMD64/x86_64" version="latest" build="2019-09-26"

ENV SECRET "E9pY8ptiyUIqmHUlKgG9gK/xcwmADsSWuYb9AS7tI8Y="
ENV TRACKER_LIST_URL "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt"
ENV EXCLUDE_TRACKER_LIST_URL "https://raw.githubusercontent.com/ngosang/trackerslist/master/blacklist.txt"

EXPOSE 26800

WORKDIR /
VOLUME ["/data"]
VOLUME ["/conf"]

COPY shell /etc/aria
ADD aria2.conf /etc/aria2/aria2.conf
ADD requirements.txt /etc/aria2/requirements.txt

RUN set -ex \
    \
    && apk update \
    && mkdir -p /conf \
    && mkdir -p /data \
    && apk --no-cache add aria2 python3 python3-dev \
    && python3 -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip3 install --default-timeout=100 --no-cache-dir --upgrade pip \
    && pip3 install --default-timeout=100 --no-cache-dir --upgrade setuptools \
    && pip3 install --default-timeout=100 --no-cache-dir --upgrade -r /etc/aria2/requirements.txt \
    && chmod +x /etc/aria2/shell/start.sh \
    && rm -rf /var/cache/apk/*

CMD ["/etc/aria2/start.sh"]
