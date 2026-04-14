FROM debian:13

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    bc \
    ca-certificates \
    build-essential \
    bzip2 \
    cpio \
    curl \
    file \
    g++ \
    gcc \
    git \
    libclang-dev \
    locales \
    make \
    ninja-build \
    openssh-client \
    patch \
    perl \
    python3 \
    rsync \
    sudo \
    tmux \
    unzip \
    vim \
    wget \
    xz-utils \
    && sed -i 's/^# *en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

WORKDIR /work

CMD ["bash"]