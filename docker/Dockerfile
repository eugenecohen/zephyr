FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

ARG username=foo
ARG uid=1000
ARG groupname=foo
ARG gid=1000

ARG HTTP_PROXY=
ARG HTTPS_PROXY=
ENV http_proxy=$HTTP_PROXY
ENV https_proxy=$HTTPS_PROXY

RUN dpkg --add-architecture i386

RUN apt-get update

RUN apt-get install -y \
    build-essential \
    make

# zephyr stuff
RUN apt install -y --no-install-recommends git ninja-build gperf \
  ccache dfu-util device-tree-compiler wget \
  python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
  make gcc gcc-multilib g++-multilib libsdl2-dev

# 32 bit support for native posix
RUN apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386

# newer cmake
RUN apt install -y software-properties-common
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null |  apt-key add -
RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
RUN apt update && apt install -y cmake

# newer dtc
RUN wget -O device-tree-compiler_1.4.7-1_amd64.deb https://launchpad.net/ubuntu/+source/device-tree-compiler/1.4.7-1/+build/15279267/+files/device-tree-compiler_1.4.7-1_amd64.deb
RUN apt install ./device-tree-compiler_1.4.7-1_amd64.deb

RUN pip3 install -U west

# install required python packages
COPY requirements.txt .
RUN pip3 install -r requirements.txt

RUN if [ -z "`getent group $gid`" ]; then \
      groupadd -g $gid -r $groupname; \
      echo created group $gid $groupname; \
    else \
      echo existing group: $(getent group $gid); \
    fi

RUN if [ -z "`getent passwd $uid`" ]; then \
      useradd -u $uid -r -g $groupname $username; \
      echo created user $uid $username $groupname; \
    else \
      echo need to update user $username to $groupname; \
    fi

RUN mkdir -p /build && chown $username /build

USER $username

