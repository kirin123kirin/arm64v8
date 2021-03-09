FROM ubuntu:latest as pyenv_org
ENV CFLAGS='-O2' \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
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
       gosu \

    && mkdir -p -m 0700 ~/.ssh && ssh-keyscan gitlab.com github.com | sort > ~/.ssh/known_hosts \

    && curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
    && echo 'export PATH="/root/.pyenv/bin:$PATH"' >> /root/.bash_profile \
    && echo 'eval "$(pyenv init -)"' >> /root/.bash_profile \
    && echo 'export PATH="/root/.pyenv/bin:$PATH"' >> /root/.profile \
    && echo 'eval "$(pyenv init -)"' >> /root/.profile \
    && true

SHELL ["/bin/bash", "-lc"]
#ENTRYPOINT ["/bin/bash", "-lc"]

FROM pyenv_org as pyenv_prebuild
ARG BUILD_PYTHON_VERSIONS="3.9.2 3.8.8 3.7.9 3.6.13"

COPY docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh \
    && for pyver in $BUILD_PYTHON_VERSIONS; do pyenv install $pyver; done \
    && pyenv global $BUILD_PYTHON_VERSIONS \
    && pyenv rehash \
    && for ver in `ls ~/.pyenv/versions`; do pyenv local $ver; python3 -m pip install -U pip; pip3 install -U setuptools wheel cython; done \
    && ln -s /usr/bin/aarch64-linux-gnu-gcc /usr/local/bin/gcc \
    && for be in `ls -d ~/.pyenv/versions/*/lib/python*/distutils/command/build_ext.py`; do sed -i.bak 's/return os.path.join(\*ext_path) + ext_suffix/return os.path.join(\*ext_path) + "-".join(ext_suffix.split("-")[:2]) + os.path.splitext(ext_suffix)[-1]/g' $be; done \
    && . /root/.bash_profile \
    && mkdir -p /app/dist \
    && true
ONBUILD COPY . /app
WORKDIR /app
VOLUME /app
ENTRYPOINT ["/docker-entrypoint.sh"]
