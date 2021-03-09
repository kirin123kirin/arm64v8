#!/bin/bash -l

USER_ID=${UID:-9001}
GROUP_ID=${GID:-9001}
PLAT_NAME=${PLAT_NAME:manylinux2014_aarch64}

useradd -u $USER_ID -o -m user -s /bin/bash
groupmod -g $GROUP_ID user

if [ "$#" -eq 0 ]; then
  echo "Starting with UID : $USER_ID, GID: $GROUP_ID"
  export HOME=/home/user
  for ver in `ls /usr/pyenv/versions`; do
      /usr/sbin/gosu user pyenv local $ver
      /usr/sbin/gosu user python setup.py bdist_wheel -p $PLAT_NAME
  done
else
  exec "$@"
fi
