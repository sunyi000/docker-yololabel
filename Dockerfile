FROM jlesage/baseimage-gui:ubuntu-22.04-v4.5.2 AS build

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Berlin
ENV NVIDIA_VISIBLE_DEVICES "all",
ENV NVIDIA_DRIVER_CAPABILITIES "compute,utility"
ENV LANG en_US.UTF-8 \
    LC_ALL en_US.UTF-8 \
    LANGUAGE en_US:en  \
    NUMBA_CACHE_DIR /tmp

RUN apt-get update -y && apt-get install -qqy build-essential 

RUN apt-get install -y -q --no-install-recommends \
            gcc \
            tar \
            wget \
            qtcreator \
            python3-dev \
            python3-pip \
            python3-wheel \
            libblas-dev \
            liblapack-dev \
            libgl1 \
            mesa-utils \
            libgl1-mesa-glx \
            libxcb-xinerama0 \
            libatlas-base-dev \
            gfortran \
            apt-utils \
            bzip2 \
            ca-certificates \
            curl \
            locales \
            libarchive-dev \
            libxkb* \
            cmake \
            libxcb-cursor0 \
            unzip &&  apt-get clean


RUN rm -rf /var/lib/apt/lists/* 

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

WORKDIR /opt
RUN wget https://github.com/developer0hye/Yolo_Label/releases/download/v1.2.1/YoloLabel_v1.2.1.tar && \
    tar -xvf YoloLabel_v1.2.1.tar


ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libstdc++.so.6"
ENV LD_LIBRARY_PATH "/usr/local/nvidia/lib:/usr/local/nvidia/lib64"


EXPOSE 5800

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

ENV APP_NAME="YoloLabel"

ENV KEEP_APP_RUNNING=0
ENV TAKE_CONFIG_OWNERSHIP=1

WORKDIR /config
