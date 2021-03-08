
ARG IMAGE_VERSION=latest
FROM arm64v8/alpine:$IMAGE_VERSION
ENV CFLAGS='-O2'
ARG PY_VERSIONS="3.9.1 3.8.7 3.7.9 3.6.12"

RUN apk add --no-cache \
        cargo \
        curl \
        bash \
        openssh-client \
        # PyEnv deps
        bzip2-dev coreutils dpkg-dev dpkg expat-dev \
        findutils gcc gdbm-dev libc-dev libffi-dev libnsl-dev libtirpc-dev \
        linux-headers make ncurses-dev openssl-dev pax-utils readline-dev \
        sqlite-dev tcl-dev tk tk-dev util-linux-dev xz-dev zlib-dev \
    # github,gitlab ssh
    && mkdir -p -m 0700 ~/.ssh && ssh-keyscan gitlab.com github.com | sort > ~/.ssh/known_hosts \
    # install pyenv
    && curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
    && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /root/.bash_profile \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /root/.bash_profile \
    && echo 'eval "$(pyenv init -)"' >> /root/.bash_profile \
    && bash -l

RUN for pyver in $PY_VERSIONS; do pyenv install $pyver; done \
    && pyenv rehash
    && pyenv global $PY_VERSIONS
    && for ver in $PY_VERSIONS; do pyenv local $ver; python -m pip install -U pip \
       pip install -U setuptools wheel cython; done
    

COPY docker-entrypoint.sh
ONBUILD COPY . /app
WORKDIR /app
ENTRYPOINT ["/docker-entrypoint.sh"]
