# docker-aria2
[![Build Status](https://cloud.drone.io/api/badges/storezhang/docker-aria2/status.svg)](https://cloud.drone.io/storezhang/docker-aria2)

基于Alpine的Aria容器，提供了自动更新最佳Tracker的功能

## 特点
- 基于Alpine，空间占用小
- 自动更新最佳Tracker，提高BT下载速度

## 使用方法
```shell script
sudo docker run \
  --volume=/volume1/docker/aria2/conf:/conf \
  --volume=/volume1/docker/aria2/data:/data \
  --volume=/volume4/video/电影:/data/电影 \
  --env=USER_UID=$(id -u usernamexxx) \
  --env=USER_GID=$(id -g usernamexxx) \
  --env=SECRET="your secret" \
  --publish=26800:26800 \
  --restart=always \
  --detach=true \
  --name=aria2 \
  storezhang/aria2:1.34.0
```
