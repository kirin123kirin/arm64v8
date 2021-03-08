#!/bin/sh -e
if [ "$#" -eq 0 ]; then
  find tests  -type d -name '__pycache__' -print0 | xargs -0 rm -rf {}
  pyenv rehash
  for ver in `ls ~/.pyenv/versions`; do pyenv local $ver; python setup.py bdist_wheel -p aarch64; done
else
  exec "$@"
fi
