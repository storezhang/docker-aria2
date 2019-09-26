FROM storezhang/alpine

MAINTAINER storezhang "storezhang@gmail.com"
LABEL architecture="AMD64/x86_64" version="latest" build="2019-09-26"

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
    && chmod +x /etc/aria2/start.sh
    && rm -rf /var/cache/apk/*

CMD ["/etc/aria2/start.sh"]
