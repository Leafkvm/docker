FROM debian:13

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    bc \
    bison \
    ca-certificates \
    build-essential \
    bzip2 \
    cpio \
    curl \
    device-tree-compiler \
    erofs-utils \
    file \
    flex \
    g++ \
    gcc \
    gcc-aarch64-linux-gnu \
    git \
    libclang-dev \
    libgnutls28-dev \
    libssl-dev \
    locales \
    lz4 \
    make \
    ninja-build \
    openssh-client \
    patch \
    perl \
    python3 \
    python3-dev \
    python3-pyelftools \
    python3-setuptools \
    rsync \
    sudo \
    swig \
    tmux \
    unzip \
    vim \
    wget \
    xz-utils \
    zstd \
    && sed -i 's/^# *en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/python3 /usr/local/bin/python2

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

WORKDIR /work

CMD ["bash"]