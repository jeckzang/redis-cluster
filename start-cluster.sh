#!/bin/bash

# Settings
PORT=6999
TIMEOUT=2000
NODES=6
REPLICAS=1

# You may want to put the above config parameters into config.sh in order to
# override the defaults without modifying this script.

if [ -a config.sh ]
then
    source "config.sh"
fi

# Computed vars
ENDPORT=$((PORT+NODES))
HOSTS=""
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
