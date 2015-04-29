#!/bin/bash
set -e
echo 'current dir:'
echo `pwd`
echo 'current ip:'
ifconfig eth0|grep 'inet '|cut -d: -f2|awk '{ print $1}'
if [ "$1" = 'redis-server' ]; then
echo "cmd:$@"
shift
echo "cmd:$@"
exec gosu redis "$@"
fi
exec "$@"
