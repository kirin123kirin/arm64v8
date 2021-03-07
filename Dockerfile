
ARG IMAGE_VERSION=latest
FROM arm64v8/alpine:$IMAGE_VERSION as pyenv_clean
ENV CFLAGS='-O2'

RUN apk add --no-cache \
        cargo \
        curl \
        # git \
        bash \
        openssh-client \
        # PyEnv deps
        bzip2-dev coreutils dpkg-dev dpkg expat-dev \
        findutils gcc gdbm-dev libc-dev libffi-dev libnsl-dev libtirpc-dev \
        linux-headers make ncurses-dev openssl-dev pax-utils readline-dev \
        sqlite-dev tcl-dev tk tk-dev util-linux-dev xz-dev zlib-dev \
    # githublab ssh
    && mkdir -p -m 0700 ~/.ssh && ssh-keyscan gitlab.com github.com | sort > ~/.ssh/known_hosts \
    # install pyenv
    && curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
    && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /root/.bash_profile \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /root/.bash_profile \
    && echo 'eval "$(pyenv init -)"' >> /root/.bash_profile \
    && true
