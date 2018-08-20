$ cat /usr/local/bin/goto
#!/bin/sh

HOST_PREFIX="$1"
LOGIN_USER="$2"

if test -z "$LOGIN_USER"; then
  LOGIN_USER="$USER"
fi

if test -z "$HOST_PREFIX"; then
  echo "useage: goto 'host_prefix' ['user']"
else
  host="$HOST_PREFIX.enai.corp"
  echo "login into $host with $LOGIN_USER"
  ssh $host -p22 -l$LOGIN_USER
fi