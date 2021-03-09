#!/bin/bash -le

USER_ID=${LOCAL_UID:-9001}
GROUP_ID=${LOCAL_GID:-9001}

echo "Starting with UID : $USER_ID, GID: $GROUP_ID"
useradd -u $USER_ID -o -m user
groupmod -g $GROUP_ID user
export HOME=/app

if [ "$#" -eq 0 ]; then
  for ver in `ls ~/.pyenv/versions`; do
      exec /usr/sbin/gosu user pyenv local $ver
      exec /usr/sbin/gosu user python setup.py bdist_wheel -p aarch64
  done
else
  exec /usr/sbin/gosu user "$@"
fi
