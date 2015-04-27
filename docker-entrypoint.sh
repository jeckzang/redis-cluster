#!/bin/bash
set -e
echo `pwd`
if [ "$1" = 'redis-server' ]; then
echo "cmd:$@"
shift
echo "cmd:$@"
exec gosu redis "$@"
fi
exec "$@"
