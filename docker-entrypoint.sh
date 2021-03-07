#!/bin/bash -l
set -e
if [ "$#" -eq 0 ]; then
  find tests  -type d -name '__pycache__' -print0 | xargs -0 rm -rf {}
  pyenv rehash
  pyenv versions
else
  exec "$@"
fi
