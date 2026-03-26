FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
        nasm \
        gcc \
        gcc-multilib \
        libc6-dev \
        libc6-dev-i386 \
        make \
        curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

CMD ["/bin/bash"]
