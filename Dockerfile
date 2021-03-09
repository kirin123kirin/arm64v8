FROM ubuntu:latest as pyenv_org
ENV CFLAGS='-O2' \
    DEBIAN_FRONTEND=noninteractive

COPY docker-entrypoint.sh /
ARG BUILD_PYTHON_VERSIONS="3.9.2 3.8.8 3.7.9 3.6.13"
#ARG BUILD_PYTHON_VERSIONS="3.9.2"

RUN chmod a+x /docker-entrypoint.sh \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       bash \
       cargo \
       curl \
       ca-certificates \
       git-core \
       make \
       llvm \
       crossbuild-essential-arm64 \
       openssh-client \
       libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget \
       libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
       tzdata \
       gosu \
    && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && mkdir -p -m 0700 ~/.ssh && ssh-keyscan gitlab.com github.com | sort > ~/.ssh/known_hosts \
    && umask 000 \
    && chmod 755 /root \
    && export PYENV_ROOT=/usr/pyenv \
    && curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
    && ln -sf /usr/pyenv/libexec/pyenv /usr/local/bin/pyenv \
    && echo 'export PYENV_ROOT=/usr/pyenv' > /etc/profile.d/pyenv_init.sh \
    && pyenv init - >> /etc/profile.d/pyenv_init.sh \
    && pyenv virtualenv-init - > /etc/profile.d/pyenv_vertualenv_init.sh \
    && chmod 644 /etc/profile.d/pyenv_*.sh \
    && for pyver in $BUILD_PYTHON_VERSIONS; do pyenv install $pyver; done \
    && pyenv global $BUILD_PYTHON_VERSIONS \
    && . /etc/profile.d/pyenv_init.sh && . /etc/profile.d/pyenv_vertualenv_init.sh \
    && pyenv rehash \
    && for ver in `ls /usr/pyenv/versions`; do pyenv local $ver; python3 -m pip install -U pip; pip3 install -U setuptools wheel cython; done \
    && ln -s /usr/bin/aarch64-linux-gnu-gcc /usr/local/bin/gcc \
    && for be in `ls -d /usr/pyenv/versions/*/lib/python*/distutils/command/build_ext.py`; do sed -i.bak 's/return os.path.join(\*ext_path) + ext_suffix/return os.path.join(\*ext_path) + "-".join(ext_suffix.split("-")[:2]) + os.path.splitext(ext_suffix)[-1]/g' $be; done \
    && mkdir /app \
    && apt clean \
    && rm -rf /root/.cache \
    && true

WORKDIR /app
VOLUME /app
ENTRYPOINT ["/docker-entrypoint.sh"]
