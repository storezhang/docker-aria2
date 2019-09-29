FROM storezhang/alpine


MAINTAINER storezhang "storezhang@gmail.com"
LABEL architecture="AMD64/x86_64" version="latest" build="2019-09-26"
LABEL Description="基于Alpine的Aria2镜像，增加自动更新BT Tracker功能。"


ENV USERNAME aria2
ENV UID 1000
ENV GID 1000
ENV SECRET "E9pY8ptiyUIqmHUlKgG9gK/xcwmADsSWuYb9AS7tI8Y="


EXPOSE 26800


WORKDIR /
VOLUME ["/data"]
VOLUME ["/conf"]


ADD requirements.txt /etc/aria2/requirements.txt


RUN set -ex \
    \
    && addgroup -g ${GID} -S ${USERNAME} \
    && adduser -u ${UID} -g ${GID} -S ${USERNAME} \
    \
    && apk update \
    \
    && mkdir -p /conf \
    && mkdir -p /data \
    \
    && apk --no-cache add bash s6 aria2 python3 python3-dev \
    && python3 -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip3 config set global.index-url http://mirrors.aliyun.com/pypi/simple/ \
    && pip3 config set global.trusted-host mirrors.aliyun.com \
    && pip3 install --default-timeout=100 --no-cache-dir --upgrade pip setuptools \
    && pip3 install --default-timeout=100 --no-cache-dir --upgrade -r /etc/aria2/requirements.txt \
    \
    && rm -rf /var/cache/apk/*


COPY root /


ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]
