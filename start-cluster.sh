#!/bin/bash

# Settings
PORT=6999
TIMEOUT=2000
NODES=6
REPLICAS=1


# Computed vars
ENDPORT=$((PORT+NODES))
HOSTS=""
IP=`ifconfig eth0|grep 'inet '|cut -d: -f2|awk '{ print $1}'`
# change redis config bind ip
cd /redis && grep -rl '# bind 127.0.0.1' ./|grep 700 |xargs sed -i "s/# bind 127.0.0.1/bind $IP 127.0.0.1/g"
while [ $((PORT < ENDPORT)) != "0" ]; do
    PORT=$((PORT+1))
    echo "Starting $PORT"
    HOSTS="$HOSTS 127.0.0.1:$PORT"
    cd /redis/${PORT} && nohup redis-server /redis/${PORT}/redis.conf &
done
/redis/redis-trib.rb create --replicas $REPLICAS $HOSTS
read answer
while [ "$answer" != "yes" ];do
    echo -n "Exit this, Please enter yes:"
    read answer
done
exit 0
