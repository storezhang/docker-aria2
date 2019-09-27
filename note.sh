sudo docker run \
  --volume=/home/storezhang/aria2/conf:/conf \
  --volume=/home/storezhang/aria2/data:/data \
  --env=USER_UID=$(id -u storezhang) \
  --env=USER_GID=$(id -g storezhang) \
  --env=SECRET="Ex9pY8ptiyUIqmHdlqUlKfogG9gK/xcwmADsSWuYstb1b9AS7tI8Y=" \
  --publish=26800:26800 \
  --name=aria2 \
  storezhang/aria2:1.0.5